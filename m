Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761463Ab2FEJgP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 05:36:15 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:37776 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754202Ab2FEJgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 05:36:13 -0400
Message-ID: <4FCDD308.8070204@gmail.com>
Date: Tue, 05 Jun 2012 13:36:08 +0400
From: George Shuklin <george.shuklin@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120530 Thunderbird/13.0
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: "H. Peter Anvin" <hpa@zytor.com>, Casey Schaufler <casey@schaufler-ca.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Why minor is still 8 bit?
References: <4FCC0E6D.9000206@gmail.com>  <20120604013504.GU30000@ZenIV.linux.org.uk> <4FCC3151.1040503@gmail.com>  <4FCCDE2B.3020306@schaufler-ca.com> <4FCD0591.2050504@gmail.com>  <4FCD5869.8000306@zytor.com> <4FCD5BF3.30707@gmail.com> <1338888208.4971.30.camel@x61.thuisdomein>
In-Reply-To: <1338888208.4971.30.camel@x61.thuisdomein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05.06.2012 13:23, Paul Bolle wrote:
> On Tue, 2012-06-05 at 05:08 +0400, George Shuklin wrote:
>> Anyway, using LVM to provide logical volumes to customers seems be fine
>> (at least by name). But that limitation for minor is breaking whole idea.
> man 8 vgcreate reads (in part):
>      -l, --maxlogicalvolumes MaxLogicalVolumes
>          Sets the maximum number of logical volumes allowed in this
>          volume group. The setting can be changed with vgchange. For
>          volume groups with metadata in lvm1 format, the limit and
>          default value is 255. If the metadata uses lvm2 format, the
>          default value is 0 which removes this restriction: there is then
>          no limit.
>
> Doesn't that option work for you (assuming you're not stuck on lvm1
> format)? If not, where do things go wrong?
>
> (Note that I never worry about this limit, since I never use more than a
> handful of logical volumes per volume group.)
>
This is a limitaiton of LMV itself. I'm talking about making those LV 
active (visible in system). When you trying to activate too much LV, you 
will get 'device io ctl failed' message.
