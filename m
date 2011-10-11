Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945Ab1JKU1E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 16:27:04 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:26821 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528Ab1JKU1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 16:27:01 -0400
Date: Tue, 11 Oct 2011 16:08:41 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, rjw@sisk.pl, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, len.brown@intel.com,
        joseph.cihula@intel.com, shane.wang@intel.com,
        xen-devel@lists.xensource.com, linux-pm@lists.linux-foundation.org,
        tboot-devel@lists.sourceforge.net, linux-acpi@vger.kernel.org,
        liang.tang@oracle.com, ke.yu@intel.com, kevin.tian@intel.com,
        jeremy@goop.org
Subject: Re: [PATCH v2] ACPI S3 to work under Xen.
Message-ID: <20111011200841.GA21943@phenom.oracle.com>
References: <1317327414-24072-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317327414-24072-1-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4E94A65F.024E:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 04:16:46PM -0400, Konrad Rzeszutek Wilk wrote:
> Attached is an [v2] set of patches to enable S3 to work with the Xen hypervisor.
> 
> Changes since the RFC posting [http://comments.gmane.org/gmane.linux.acpi.devel/50701] by
> Liang Tang:
>  - Per review comments added: __unused__ attribute, support for PM1A/B if more than 16-bit,
>    copyright/license.
>  - Added support for PHYSDEVOP_restore_msi_ext call.

Rafael, Len,

Any chance you could take look at the patches - the parts that touch the ACPI
generic components are couple of lines? Much appreciated.

Joseph was OK with the tboot sections.
