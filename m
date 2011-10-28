Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab1J1KiJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 06:38:09 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47970 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258Ab1J1KiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 06:38:07 -0400
MIME-Version: 1.0
In-Reply-To: <1319782638.22700.8.camel@dabdike>
References: <1319782638.22700.8.camel@dabdike>
From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 28 Oct 2011 12:37:44 +0200
X-Google-Sender-Auth: yhOL7Gl-CLD5adl0ab2HfBmMb0M
Message-ID: <CAO+b5-poCGta55VVZCLc_YsJDyZzGHs=zmvFT8pRqns-xw5vaQ@mail.gmail.com>
Subject: Re: [GIT PULL] first round of SCSI updates for the 3.1 merge window
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 8:17 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> This represents the usual round of driver updates [ ... ]

Have these two patches perhaps been overlooked ?
* Make scsi_free_queue() kill pending SCSI commands, which fixes a
kernel deadlock that is easy to trigger from user space
(http://marc.info/?l=linux-scsi&m=131680195721932).
* srp_transport: Fix atttribute registration race
(http://marc.info/?l=linux-rdma&m=131921626507904).

Bart.
