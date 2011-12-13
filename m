Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab1LMIxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 03:53:10 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41022 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751660Ab1LMIxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 03:53:08 -0500
Subject: Re: [PATCH 1/1] scsi: retrieve cache mode using ATA_16 if normal
 routine fails
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: Amit Sahrawat <amit.sahrawat83@gmail.com>,
        Nam-Jae Jeon <namjae.jeon@samsung.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <CAKYAXd-3LYJUWbAqaT4XfbNXJ_F0L1Lxu1evUxLyu=poHLMFug@mail.gmail.com>
References: <1323688722-25400-1-git-send-email-amit.sahrawat83@gmail.com>
	 <1323694267.20451.5.camel@dabdike>
	 <CAKYAXd-3LYJUWbAqaT4XfbNXJ_F0L1Lxu1evUxLyu=poHLMFug@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Dec 2011 12:53:02 +0400
Message-ID: <1323766382.8163.12.camel@dabdike>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-13 at 09:20 +0900, Namjae Jeon wrote:
> > This whole patch looks like a layering violation.  Why not just update
> > the SAT layer to translate the MODE SENSE correctly?
> Would plz you explain more ? I didn't clearly understand your point yet.

The ATA layer does translation for SCSI commands.  Just translate the
mode sense correctly to use IDENTIFY word 85.  It's a smaller patch and
no need for any changes in SCSI.

Actually, looking at it, it seems to be correct ... why is it not
working for you?

James


