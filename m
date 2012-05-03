Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755486Ab2ECKlS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 06:41:18 -0400
Received: from smtprelay03.ispgateway.de ([80.67.31.30]:52922 "EHLO
	smtprelay03.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab2ECKlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 06:41:17 -0400
Message-ID: <4FA261C3.6030403@ladisch.de>
Date: Thu, 03 May 2012 12:45:23 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steve French <smfrench@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Line endings now altered when saving kernel patches via gmail
References: <CAH2r5mt8XwHQ5Q-BfpxBp2o5=guafNtxGcEvFcLRTu7EwZjMJg@mail.gmail.com>
In-Reply-To: <CAH2r5mt8XwHQ5Q-BfpxBp2o5=guafNtxGcEvFcLRTu7EwZjMJg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve French wrote:
> I noticed sometime in the last month that one of the normal patch
> processes (open up gmail, find the email that contains the patch, then
> "show original" then "save as ...") doesn't work anymore.  Gmail
> appears to now corrupt patches by inserting DOS line endings (at
> least) even when "show original" - any idea how to turn this off.

SMTP mails always use CR/LF line endings in the body.  If the older
gmail did not show them in the source view, this was a bug, which
has now been fixed.

Tools like "git am" automatically convert line endings from mail
to Unix.  If your tools don't handle this, you'll have to convert
the files manually after saving them.


Regards,
Clemens
