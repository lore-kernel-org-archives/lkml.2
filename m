Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322Ab0FYXej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 19:34:39 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48300 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932240Ab0FYXei convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 19:34:38 -0400
MIME-Version: 1.0
In-Reply-To: <bb9a6620-ccf1-4f5b-a1cd-97f93bad4baa@SG2EHSMHS007.ehs.local>
References: <20100625220300.6903.3519.stgit@angua> <b392c10f-78bb-466d-a3e0-cf5b95edb4cb@VA3EHSMHS014.ehs.local> 
	<AANLkTilvOpCVrbT4YPaw3NZUCnKgUN7IUQzQGMfihbSG@mail.gmail.com> 
	<bb9a6620-ccf1-4f5b-a1cd-97f93bad4baa@SG2EHSMHS007.ehs.local>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 25 Jun 2010 17:34:17 -0600
X-Google-Sender-Auth: wouK8jgONha5SdMUgCqsvg2Do7w
Message-ID: <AANLkTik_lg0H4-ajyuCmH9LwhY0nAfo4-sax8ETC984h@mail.gmail.com>
Subject: Re: [PATCH] of/flattree: Use common ALIGN() macro instead of 
	archspecific _ALIGN
To: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Cc: benh@kernel.crashing.org, monstr@monstr.eu,
       microblaze-uclinux@itee.uq.edu.au, devicetree-discuss@lists.ozlabs.org,
       linux-kernel@vger.kernel.org, jeremy.kerr@canonical.com,
       sfr@canb.auug.org.au
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 25, 2010 at 5:18 PM, Stephen Neuendorffer
<stephen.neuendorffer@xilinx.com> wrote:
>> -----Original Message-----
>> From: glikely@secretlab.ca [mailto:glikely@secretlab.ca] On Behalf Of Grant Likely
>> Sent: Friday, June 25, 2010 4:16 PM
>> To: Stephen Neuendorffer
>> Cc: benh@kernel.crashing.org; monstr@monstr.eu; microblaze-uclinux@itee.uq.edu.au; devicetree-
>> discuss@lists.ozlabs.org; linux-kernel@vger.kernel.org; jeremy.kerr@canonical.com;
>> sfr@canb.auug.org.au
>> Subject: Re: [PATCH] of/flattree: Use common ALIGN() macro instead of archspecific _ALIGN
>>
>> On Fri, Jun 25, 2010 at 4:49 PM, Stephen Neuendorffer
>> <stephen.neuendorffer@xilinx.com> wrote:
>> > Grant,
>> >
>> > I need this for the PCI project.  I also have a couple of other
>> > generalizations of the drivers/of code
>> > to get it to run after boot time in an X86 system...
>>
>> Send me your patches!  :-)  Get them to me soon and I'll queue them up
>> for the next merge window.
>>
>> g.
>
> Dangit, I just got the code compiling, and now I find out that X86 doesn't support out_be32()...  :)
> You'd think that somewhere somebody might have realized that all the duplicated driver macros that
> do that are a bad idea...

:-)

I think iowrite32be should be cross-arch safe.  in_*, out_* was mostly
a powerpc/sparc thing.

g.
