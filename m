Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab1GLNbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 09:31:42 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:40386 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948Ab1GLNbk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 09:31:40 -0400
Date: Tue, 12 Jul 2011 09:31:19 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Cong Wang <amwang@redhat.com>
Cc: Takao Indoh <indou.takao@jp.fujitsu.com>, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, vgoyal@redhat.com, rdunlap@xenotime.net,
        lenb@kernel.org, linux-doc@vger.kernel.org, linux-acpi@vger.kernel.org,
        mjg@redhat.com
Subject: Re: [PATCH v2] acpi: introduce "acpi_rsdp=" parameter for kdump
Message-ID: <20110712133119.GA7377@dumpdata.com>
References: <E8CC3FDD41FF9Findou.takao@jp.fujitsu.com>
 <4E1C223A.9000705@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4E1C223A.9000705@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090206.4E1C4CB4.0034:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 06:30:18PM +0800, Cong Wang wrote:
> 于 2011年07月11日 23:14, Takao Indoh 写道:
> >Revised version of the patch which was posted by Cong WANG
> >
> >Changes in v2:
> >* Change parameter name from "acpi_addr" to "acpi_rsdp"
> >* Add CONFIG_KEXEC
> 
> Thanks for updating it! Definitely looks good to me,

The only comment I've is that it would be good to include in the
patch description which sysfs attribute is used by the kexec tools
to read in the physical address to be passed in.

Otherwise it looks good to me too.
> 
> Reviewed-by: WANG Cong <amwang@redhat.com>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
