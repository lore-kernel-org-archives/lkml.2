Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423050Ab2CPPoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 11:44:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161465Ab2CPPoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 11:44:13 -0400
Message-ID: <4F635FC1.40606@redhat.com>
Date: Fri, 16 Mar 2012 12:44:01 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Borislav Petkov <bp@amd64.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Add a per-dimm structure
References: <1331120438-27523-1-git-send-email-mchehab@redhat.com> <20120313233217.GB31106@kroah.com> <4F60F2E4.7060707@redhat.com> <20120314204355.GA10187@kroah.com> <20120314223102.GA27602@aftab> <4F61496D.8030000@redhat.com> <20120315113115.GA32149@aftab> <4F61E35B.9000906@redhat.com> <20120315213844.GA3781@aftab> <4F62FE38.6060704@redhat.com> <20120316153001.GH28696@kroah.com>
In-Reply-To: <20120316153001.GH28696@kroah.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 16-03-2012 12:30, Greg KH escreveu:
> On Fri, Mar 16, 2012 at 05:47:52AM -0300, Mauro Carvalho Chehab wrote:
>> 2) per Greg's request, we should not use struct sysdev, using instead,
>>    struct device. That means that everything under
>> 	/sys/devices/system/edac/mc/
>>    will move to another place, likely:
>> 	/sys/devices/ras/
> 
> No, you can keep things under /sys/devices/system/edac/ if you use a
> struct device, no need to move things and break userspace tools if you
> don't have to.

Hmm... How?

> 
> And I don't think you have to.
> 
> thanks,
> 
> greg k-h

