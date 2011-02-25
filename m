Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636Ab1BYQid (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 11:38:33 -0500
Received: from mga02.intel.com ([134.134.136.20]:27280 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932463Ab1BYQic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 11:38:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,226,1297065600"; 
   d="scan'208";a="606554030"
Message-ID: <4D67DAF2.8090501@intel.com>
Date: Fri, 25 Feb 2011 08:38:10 -0800
From: Dan Williams <dan.j.williams@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Jiang, Dave" <dave.jiang@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        David Milburn <dmilburn@redhat.com>
Subject: Re: [RFC PATCH] x86: Moving probe_roms_32 to probe_roms
References: <20110222201538.15443.81915.stgit@localhost6.localdomain6>	 <AANLkTikimHCsFmavDoXn3Pka8WWMePqk+hNUK8h=DqSQ@mail.gmail.com>	 <4D670B07.90005@zytor.com> <1298628822.11506.21.camel@dwillia2-linux>
In-Reply-To: <1298628822.11506.21.camel@dwillia2-linux>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2011 02:13 AM, Williams, Dan J wrote:
[..]
> +		if (probe_kernel_address(rom + offset + 0x8, list) != 0 &&
> +		    probe_kernel_address(rom + offset + 0xc, rev) != 0 &&

These should be "== 0", but you get the idea...


> +		    rev>= 3&&  list&&
> +		    probe_list(pdev, vendor, rom + offset + list)) {
> +			oprom = res;
> +			break;
> +		}
> +	}

--
Dan
