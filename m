Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab0GaRqW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 13:46:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36925 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572Ab0GaRqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 13:46:21 -0400
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
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C3DBCC8483@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C3D0804533@cosmail02.lsi.com>
	 <AANLkTikM_rCfKKUd9vokhBi_YWg5qIPRKsnfiQiluFwl@mail.gmail.com>
	 <1277046060.5242.18.camel@mulgrave.site>
	 <4B6A08C587958942AA3002690DD4F8C3D09275CC@cosmail02.lsi.com>
	 <1277063250.5242.25.camel@mulgrave.site>
	 <4B6A08C587958942AA3002690DD4F8C3D09275CE@cosmail02.lsi.com>
	 <1277066924.5242.41.camel@mulgrave.site>
	 <4B6A08C587958942AA3002690DD4F8C3DBCC8483@cosmail02.lsi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 31 Jul 2010 12:46:11 -0500
Message-ID: <1280598371.2801.11.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-30 at 12:53 -0600, Yang, Bo wrote:
> Do you know when those patches (12 patches) will be pushed to upstream?

Well, it looks like I lost the branch I was fixing all this up in
somewhere.  I don't really have time to redo that work, so could you
send the series correctly (that's the 8 OCR patches that don't
individually compile as a single patch with a correct changelog plus the
four others).

Thanks,

James


