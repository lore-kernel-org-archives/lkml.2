Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760383Ab0HFAgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 20:36:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55801 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753548Ab0HFAgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 20:36:21 -0400
Subject: RE: [PATCH 1/12] scsi: megaraid_sas - Online Controller Reset - I:
 Enable Online Controller Reset Bit in register related functions
From: James Bottomley <James.Bottomley@suse.de>
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "akpm@osdl.org" <akpm@osdl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Maharana, Parag" <Parag.Maharana@lsi.com>,
        "Daftardar, Jayant" <Jayant.Daftardar@lsi.com>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C3DBD67FC4@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C3D0804533@cosmail02.lsi.com>
	 <AANLkTikM_rCfKKUd9vokhBi_YWg5qIPRKsnfiQiluFwl@mail.gmail.com>
	 <1277046060.5242.18.camel@mulgrave.site>
	 <4B6A08C587958942AA3002690DD4F8C3D09275CC@cosmail02.lsi.com>
	 <1277063250.5242.25.camel@mulgrave.site>
	 <4B6A08C587958942AA3002690DD4F8C3D09275CE@cosmail02.lsi.com>
	 <1277066924.5242.41.camel@mulgrave.site>
	 <4B6A08C587958942AA3002690DD4F8C3DBCC8483@cosmail02.lsi.com>
	 <1280598371.2801.11.camel@mulgrave.site>
	 <4B6A08C587958942AA3002690DD4F8C3DBD67FC4@cosmail02.lsi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 19:36:13 -0500
Message-ID: <1281054973.22157.5.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-05 at 14:44 -0600, Yang, Bo wrote:
> I re-submitted all 12 patches.  Can you help to push them to main tree?

That's actually not what I asked for.  I said please send the set of
individually compilable patches.  I think that's something like 1-8
rolled up as one patch with one change set and then the remaining 4 sent
as individual patches.

So let me put it this way. I'm sorry I managed to lose the tree I was
trying to build for this.  However, I have two conferences and four
talks coming up before the end of the merge window, so I have no time to
do this again.  If you want this patch set in for 2.6.36, please redo it
as indicated above ASAP.  Otherwise, I'll take another look when I get
some free time.

James


