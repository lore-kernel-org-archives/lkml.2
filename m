Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab0GWIIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 04:08:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39209 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877Ab0GWIIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 04:08:47 -0400
Message-ID: <4C494DEE.3010101@redhat.com>
Date: Fri, 23 Jul 2010 10:08:14 +0200
From: Stefan Assmann <sassmann@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Casey Leedom <leedom@chelsio.com>
CC: "Rose, Gregory V" <gregory.v.rose@intel.com>,
        David Miller <davem@davemloft.net>, shemminger@vyatta.com,
        andy@greyhouse.net, harald@redhat.com, bhutchings@solarflare.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org, gospo@redhat.com,
        "Duyck, Alexander H" <alexander.h.duyck@intel.com>
Subject: Re: [PATCH net-next] sysfs: add entry to indicate network interfaces
 with random MAC address
References: <20100721150732.GR7497@gospo.rdu.redhat.com> <20100721102816.4bef5ada@nehalam> <20100721.103249.107094774.davem@davemloft.net> <201007211129.48288.leedom@chelsio.com> <43F901BD926A4E43B106BF17856F0755F184620A@orsmsx508.amr.corp.intel.com> <4C47EAF3.3080602@redhat.com> <2408F875-69BE-45D3-8605-4AE5CDA4601C@chelsio.com>
In-Reply-To: <2408F875-69BE-45D3-8605-4AE5CDA4601C@chelsio.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.07.2010 02:26, Casey Leedom wrote:
> 
>  Or you simply don't have the VF Driver loaded in the "Domain 0" Control OS.  When we install the cxgb4 PF Driver with "num_vf=..." this enables the PCI-E SR-IOV Capabilities within the various PFs and the corresponding VF PCI Devices are instantiated and discovered by the Domain 0 Linux OS.  But without a cxgb4vf VF Driver loaded, those devices just sit there  available for "Device Assignment" to VMs.
> 

Just out of curiosity, how do you prevent the VF driver from getting
loaded in the host? Except from blacklisting it.

  Stefan
--
Stefan Assmann         | Red Hat GmbH
Software Engineer      | Otto-Hahn-Strasse 20, 85609 Dornach
                       | HR: Amtsgericht Muenchen HRB 153243
                       | GF: Brendan Lane, Charlie Peters,
sassmann at redhat.com |     Michael Cunningham, Charles Cachera
