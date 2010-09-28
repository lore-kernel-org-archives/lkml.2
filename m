Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab0I1Ip1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 04:45:27 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:46738 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441Ab0I1IpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 04:45:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:disposition-notification-to:date:from:user-agent
         :mime-version:to:cc:subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=MR14cyVgNDByIc/mgLiA4pU3DxueygycuPAW4DIqNd/we4v3WqwF8/W1Dt5sUusA1C
         vV9FTzwyHs+wDy/wnBX8pQE9k3UbQQbs5mvF7upm81ByfaZtJP0Zr1DkME7pl7Oy1hWL
         TEOTX4o3Vx4KU5Vge8bO+nFHg2AGZazeIpVnU=
Message-ID: <4CA1AB0F.908@googlemail.com>
Date: Tue, 28 Sep 2010 09:45:03 +0100
From: Mr Dash Four <mr.dash.four@googlemail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.8.1.23) Gecko/20090812 Thunderbird/2.0.0.23
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: Pablo Neira Ayuso <pablo@netfilter.org>, Eric Paris <eparis@redhat.com>,
        Paul Moore <paul.moore@hp.com>, James Morris <jmorris@namei.org>,
        linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
        netfilter-devel@vger.kernel.org, sds@tycho.nsa.gov,
        casey@schaufler-ca.com, linux-security-module@vger.kernel.org,
        netfilter@vger.kernel.org
Subject: Re: [PATCH 3/6] secmark: export binary yes/no rather than kernel
 internal secid
References: <20100924204517.28355.42822.stgit@paris.rdu.redhat.com>  <20100924204531.28355.20320.stgit@paris.rdu.redhat.com>  <alpine.LRH.2.00.1009271038280.25748@tundra.namei.org>  <1285606896.2815.36.camel@localhost.localdomain>  <1285612156.4935.16.camel@sifl> <1285615525.2815.76.camel@localhost.localdomain> <4CA11F36.2090705@netfilter.org> <alpine.LNX.2.01.1009280156170.5607@obet.zrqbmnf.qr>
In-Reply-To: <alpine.LNX.2.01.1009280156170.5607@obet.zrqbmnf.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> In netlink, we can obsolete fields without breaking backward
>> compatibility. Applications parsing the /proc entry may break, but they
>> should use stable interfaces (like netlink) instead.
>>     
>
> Which I take as a pro stance on not adding any more procfs fields.
>   
How did you figure that one out then?

