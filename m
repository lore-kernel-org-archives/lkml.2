Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585Ab1I3C5I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 22:57:08 -0400
Received: from maxipes.logix.cz ([93.89.80.122]:34946 "EHLO maxipes.logix.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755197Ab1I3C5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 22:57:06 -0400
Message-ID: <4E852FCC.9070309@logix.net.nz>
Date: Fri, 30 Sep 2011 15:56:12 +1300
From: Michal Ludvig <mludvig@logix.net.nz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ram Pai <linuxram@us.ibm.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, weiyang@linux.vnet.ibm.com,
        wangyun@linux.vnet.ibm.com, shangw@linux.vnet.ibm.com
Subject: Re: [PATCH] Resource: wrong resource window calculation
References: <CAErSpo70k6UnhvvOMgQQxJ6BHZOwym=-jaPMvOukAaCr-B0+cQ@mail.gmail.com> <4E5EFFBD.4050201@logix.net.nz> <CAErSpo6bofeiAxeRo_RjXQSnwmcWrdymn0MK8H4_CwqwoeD1jg@mail.gmail.com> <4E634814.4050508@logix.net.nz> <20110909113409.GE2416@ram-ThinkPad-T61> <4E6C05B7.9000904@logix.net.nz> <20110913110646.GB2425@ram-ThinkPad-T61> <4E6F400A.6090909@logix.net.nz> <20110922074858.GG5085@ram-ThinkPad-T61> <4E7B04F8.3090500@logix.net.nz> <20110928154200.GA2477@ram-ThinkPad-T61> <CA+55aFxAHTWu=ZVoMdfGwJ4xNgGeyk2CWrD+kJVH-qb4N=vhwA@mail.gmail.com>
In-Reply-To: <CA+55aFxAHTWu=ZVoMdfGwJ4xNgGeyk2CWrD+kJVH-qb4N=vhwA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2011 03:44 PM, Linus Torvalds wrote:
> On Wed, Sep 28, 2011 at 8:42 AM, Ram Pai<linuxram@us.ibm.com>  wrote:
>>         Do you plan to take this patch for 3.1? It fixes a regression w.r.t 3.0
>>         https://bugzilla.kernel.org/show_bug.cgi?id=42002 captures the bug report.
> It looks fine, but that bugzilla thing is currently useless. Do you
> have some other place with the symptoms, discussion etc?  I didn't
> find the original report on lkml..
>

Hi,

here is the thread from linux-pci@...

http://comments.gmane.org/gmane.linux.kernel.pci/11666

Michal
