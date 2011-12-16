Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758956Ab1LPMaq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 07:30:46 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:55225 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756594Ab1LPMai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 07:30:38 -0500
Subject: Re: unexpected taint message
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4EEB0EFC.5000302@broadcom.com> (sfid-20111216_102800_182196_AFD2D6CF)
References: <4EEB0EFC.5000302@broadcom.com>
	 (sfid-20111216_102800_182196_AFD2D6CF)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Dec 2011 13:30:36 +0100
Message-ID: <1324038636.3429.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-16 at 10:27 +0100, Arend van Spriel wrote:
> To whoever may know,
> 
> Upon loading our driver module I get the following message:
> 
> kernel: [  344.805106] Disabling lock debugging due to kernel taint
> 
> What exactly are the criteria for tainting? Our driver locking strategy
> is something we want to refactor and having lock debugging during that
> transition may be a life safer.

cat /proc/sys/kernel/tainted

johannes

