Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab2HCIj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 04:39:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55152 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987Ab2HCIjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 04:39:25 -0400
Date: Fri, 3 Aug 2012 10:39:11 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-2022-JP?Q?=1B$BN-2E=3DY=1B=28J?= <scott.liu@emc.com.tw>
Cc: "'benjamin.tissoires'" <benjamin.tissoires@gmail.com>,
        "'Dmitry Torokhov'" <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1]hid:hid-multitouch:  add mt_resume for ELAN's
 production
In-Reply-To: <C8EA045ABE09420E976A1F1D4294E737@elan.corp>
Message-ID: <alpine.LNX.2.00.1208031034320.21188@pobox.suse.cz>
References: <C8EA045ABE09420E976A1F1D4294E737@elan.corp>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-2022-JP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2012, 劉嘉駿 wrote:

> Some of ELAN’s production need to issue set_idle when resume.

Scott,

your e-mail client broke the patch in a way that it's not only impossible 
to apply it using standard tools, but it's also unreadable by eyes (a lot 
of whitespaces, broken lines, every second line is blank, etc).

Could you please fix that up and resend?

-- 
Jiri Kosina
SUSE Labs
