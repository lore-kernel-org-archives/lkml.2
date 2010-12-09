Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab0LIRH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 12:07:29 -0500
Received: from cantor.suse.de ([195.135.220.2]:34489 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754947Ab0LIRH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 12:07:27 -0500
Subject: Re: [PATCH 2/9] scsi: megaraid_sas - Driver only report tape
 drive, JBOD and logic drives
From: James Bottomley <James.Bottomley@suse.de>
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>,
        "'akpm@osdl.org'" <akpm@osdl.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "Daftardar, Jayant" <Jayant.Daftardar@lsi.com>,
        Tomas Henzl <thenzl@redhat.com>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C30106A961D6@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C3D0804533@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C3DBD67F68@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C30106A961BD@cosmail02.lsi.com>
	 <4B6A08C587958942AA3002690DD4F8C30106A961D6@cosmail02.lsi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Dec 2010 11:07:21 -0600
Message-ID: <1291914441.3002.209.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 09:53 -0700, Yang, Bo wrote:
> Driver only report tape drive, JBOD and logic drives to OS

Could you explain the point of this further?  As far as I can see, it
would prevent the driver from reporting enclosures, which it is
currently doing.

James


