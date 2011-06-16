Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965Ab1FPJeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 05:34:07 -0400
Received: from sr-smtp.usish.com ([210.5.144.203]:53543 "EHLO
	sr-smtp.usish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119Ab1FPJeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 05:34:04 -0400
From: "Jack Wang" <jack_wang@usish.com>
To: "'Xiangliang Yu'" <yuxiangl@marvell.com>,
        "'James Bottomley'" <James.Bottomley@HansenPartnership.com>
Cc: <yxlraid@gmail.com>, <lucas.demarchi@profusion.mobi>,
        <maciej.trela@intel.com>, <dan.j.williams@intel.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "'Jacky Feng'" <jfeng@marvell.com>
References: <1308064628-11826-1-git-send-email-yxlraid@gmail.com> <1308065367.2401.24.camel@mulgrave> <F766E4F80769BD478052FB6533FA745D19FAE669AF@SC-VEXCH4.marvell.com> <1308117450.2329.31.camel@mulgrave> <F766E4F80769BD478052FB6533FA745D19FAE66AAF@SC-VEXCH4.marvell.com> <637AF86F1A314F15B816411A580575F0@usish.com.cn> <F766E4F80769BD478052FB6533FA745D19FAE66CAE@SC-VEXCH4.marvell.com> <51A55E816E3847EF97FE4E849A572717@usish.com.cn> <F766E4F80769BD478052FB6533FA745D19FAE66CCA@SC-VEXCH4.marvell.com> <C8FBA6A948D643679B01520A89FAC48A@usish.com.cn> <F766E4F80769BD478052FB6533FA745D19FAE66D1E@SC-VEXCH4.marvell.com> <E3CF09ECAD244C00A4C096DB374E140E@usish.com.cn> <F766E4F80769BD478052FB6533FA745D19FAE66D88@SC-VEXCH4.marvell.com> <4F7167A354D8476AB58FD36CA6321960@usish.com.cn> <F766E4F80769BD478052FB6533FA745D19FAE66DB6@SC-VEXCH4.marvell.com> <6E6072BD03F348168F749B19B2BA90D3@usish.com.cn> <F766E4F80769BD478052FB6533FA745D19FAE66E0E@SC-VEXCH4.marvell.com>
Subject: Re: [PATCH] [SCSI] LIBSAS: fix libsas link error issue
Date: Thu, 16 Jun 2011 17:33:44 +0800
Message-ID: <F15E99167DE14EAEAEB5B795257F11BE@usish.com.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AcwrIR/qdpMMo2uOTdi6EtZ/SnmPkgAAZ5KAACgYoPAAAOfC4AABCYdAAABOEGAAA867gAAA6NjQAAMaV6AAAIc6oAABFNUQAACOI5AAAiHGgAABI+NAAAGT2dA=
In-Reply-To: <F766E4F80769BD478052FB6533FA745D19FAE66E0E@SC-VEXCH4.marvell.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6090
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> >[Jack Wang]
> >No, I mean you when you set connection rate in OPEN Address frame, you
> >compare your HBA linkrate with the linkrate of the phy you want to open,
and
> >chose the minor.
> 
> I don't understand. What is the purpose of sas_ex_get_linkrate function?
[Jack Wang] 
As I understand, this function set the linkrate(pathways max/min linkrate)
of the child device(expander or end device) attached to parent expander
parent, through parent_phy, if there's wide port also handle that.

