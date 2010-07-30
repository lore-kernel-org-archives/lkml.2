Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab0G3Hbm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 03:31:42 -0400
Received: from adelie.canonical.com ([91.189.90.139]:37733 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab0G3Hbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 03:31:41 -0400
Message-ID: <4C527FD9.3060708@canonical.com>
Date: Fri, 30 Jul 2010 00:31:37 -0700
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the security-testing
 tree
References: <20100730120624.f3112742.sfr@canb.auug.org.au> <alpine.LRH.2.00.1007301353340.8846@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.1007301353340.8846@tundra.namei.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2010 08:54 PM, James Morris wrote:
> On Fri, 30 Jul 2010, Stephen Rothwell wrote:
> 
>> Hi James,
>>
>> After merging the security-testing tree, today's linux-next build
>> (powerpc ppc64_defconfig) failed like this:
>>
>> security/Kconfig:144: can't open file "security/apparmor/Kconfig"
>>
>> Caused by commit 32bd8e5273c0be4189274ab55c4d16862f0dd87d ("AppArmor:
>> Enable configuring and building of the AppArmor security module").  Looks
>> like a file was missed.
> 
> I don't know how to use git.
> 
> Should be fixed now.
> 
works for me,

thanks James
