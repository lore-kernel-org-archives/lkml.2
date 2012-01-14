Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab2ANR1R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 12:27:17 -0500
Received: from imr3.ericy.com ([198.24.6.13]:47168 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755818Ab2ANR1P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 12:27:15 -0500
Date: Sat, 14 Jan 2012 09:25:38 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Alex Rio <scasbyte@gmail.com>
CC: "khali@linux-fr.org" <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/2] hwmon: (w83627ehf) Replace deprecated
 strict_strto*
Message-ID: <20120114172538.GD29012@ericsson.com>
References: <CAPbJ=B=Z=FRiuR0Cb5uQhtNxWoARr59iFocnd0VRzNfSKXLp_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAPbJ=B=Z=FRiuR0Cb5uQhtNxWoARr59iFocnd0VRzNfSKXLp_w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 13, 2012 at 08:39:41PM -0500, Alex Rio wrote:
> Replaces deprecated function strict_strto* to kstrto*. In the future
> the strict_strto could disappear so the replacement was done.
> I'm not sure if this is being done for all the files in a single
> patch, anyway I'm including it here just in case.
> Checkpatch.pl now leaves 5 "errors", they are mostly
> assignments inside if's statements, taking them out does not
> significantly increases readability.
> 
> Signed-off-by: Alex Rio <scasbyte@gmail.com>

Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>

Jean, do you want to take this one ? Otherwise, I'll add it to my pending list
for the next -rc.

Guenter
