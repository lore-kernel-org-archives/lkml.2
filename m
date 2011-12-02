Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab1LBS1X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 13:27:23 -0500
Received: from thoth.sbs.de ([192.35.17.2]:24619 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757189Ab1LBS1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 13:27:22 -0500
Message-ID: <4ED91871.4050904@siemens.com>
Date: Fri, 02 Dec 2011 19:26:57 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Liu Ping Fan <kernelfans@gmail.com>
CC: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        aliguori@us.ibm.com, gleb@redhat.com
Subject: Re: [PATCH] kvm: make vcpu life cycle separated from kvm instance
References: <4ED212A1.3060300@redhat.com> <1322807192-14147-1-git-send-email-kernelfans@gmail.com>
In-Reply-To: <1322807192-14147-1-git-send-email-kernelfans@gmail.com>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-12-02 07:26, Liu Ping Fan wrote:
> From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
> 
> Currently, vcpu can be destructed only when kvm instance destroyed.
> Change this to vcpu's destruction taken when its refcnt is zero,
> and then vcpu MUST and CAN be destroyed before kvm's destroy.

I'm lacking the big picture yet (would be good to have in the change log
- at least I'm too lazy to read the code):

What increments the refcnt, what decrements it again? IOW, how does user
space controls the life-cycle of a vcpu after your changes?

Thanks,
Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
