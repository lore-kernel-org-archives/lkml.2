Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab0LCN6q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 08:58:46 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:53400 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757895Ab0LCN6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 08:58:44 -0500
Date: Fri, 3 Dec 2010 14:58:41 +0100
From: Holger Eitzenberger <holger@eitzenberger.org>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Cc: netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: ctnetlink loop
Message-ID: <20101203135841.GA23610@mail.eitzenberger.org>
Mail-Followup-To: netfilter-devel <netfilter-devel@vger.kernel.org>,
	netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
References: <20101203133903.GG13225@mail.eitzenberger.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101203133903.GG13225@mail.eitzenberger.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Provags-ID: V02:K0:qpigaFI/779x+KoZCH4B5hIPDnMHvOHvfUnxlWRf8Eq
 9B72rZpK93dCSy1gRa5LcczTjumatEQXBq1A/FcnG1I/wbdnrm
 OYt4Uch53ihnnLmaAKOeGZW5wLFvSlsq6CVr8U+equlZPhekfH
 6T+1rCA85mnTM8YiqqFhHDvyuai3MqpHu9NtaKqPIk45Rjp+VF
 FWFOJmL1wfgbwBu16Alc1OuNlTasFmwutAu1AfVbjo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[changed netfilter-devel address]

I is even stuck for O_NONBLOCK sockets, which may be due to nfnl_mutex
being held in the receive path.

 /holger

