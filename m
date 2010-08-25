Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab0HYUKR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 16:10:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:52979 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604Ab0HYUKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 16:10:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,270,1280732400"; 
   d="scan'208";a="600213524"
Message-ID: <4C7578A6.2080303@linux.intel.com>
Date: Wed, 25 Aug 2010 13:10:14 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: holzheu@linux.vnet.ibm.com
CC: sam@ravnborg.org, tabbott@ksplice.com, vda.linux@googlemail.com,
        mmarek@suse.cz, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
        brueckner@linux.vnet.ibm.com, schwidefsky@de.ibm.com
Subject: Re: [PATCH] Fix initramfs size calculation
References: <1282751832.3676.17.camel@holzheu-laptop>
In-Reply-To: <1282751832.3676.17.camel@holzheu-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2010 08:57 AM, Michael Holzheu wrote:
> Certain s390 instructions, especially instructions for loading addresses
> (larl) or branch addresses must be on even addresses. 

I have to admit to finding this fairly disturbing, as this is likely to
come up again and again.  Is there any way to tell gcc (e.g. with an
alignment attribute) that a particular symbol is not safe to be loaded
with larl?

	-hpa
