Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab1AaSDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 13:03:43 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64964 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab1AaSDm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 13:03:42 -0500
MIME-Version: 1.0
In-Reply-To: <44dc88e7-3086-4762-8789-f455f3b265ec@VA3EHSMHS027.ehs.local>
References: <20110131073918.9058.37628.stgit@localhost6.localdomain6>
 <20110131074510.9058.59071.stgit@localhost6.localdomain6> <44dc88e7-3086-4762-8789-f455f3b265ec@VA3EHSMHS027.ehs.local>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 31 Jan 2011 11:03:21 -0700
X-Google-Sender-Auth: 9bvzRrEa2Ax_y9QY3O9US1RGLGw
Message-ID: <AANLkTinU7GOpDt83BHYfbzkbifW1yH3OMFS-2+6XCCe4@mail.gmail.com>
Subject: Re: [PATCH 3/3 RFC] dt: add documentation of ARM dt boot interface
To: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
Cc: devicetree-discuss@lists.ozlabs.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, sam@ravnborg.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 11:00 AM, Stephen Neuendorffer
<stephen.neuendorffer@xilinx.com> wrote:
>
>
>> -----Original Message-----
>> From: linuxppc-dev-bounces+stephen=neuendorffer.name@lists.ozlabs.org
> [mailto:linuxppc-dev-
>> bounces+stephen=neuendorffer.name@lists.ozlabs.org] On Behalf Of Grant
> Likely
>> Sent: Sunday, January 30, 2011 11:46 PM
>> To: devicetree-discuss@lists.ozlabs.org;
> linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org
>> Cc: sam@ravnborg.org
>> Subject: [PATCH 3/3 RFC] dt: add documentation of ARM dt boot
> interface
>>
>> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>> ---
>>
>> For RFC only.  I do not plan to merge this change yet.
>>
>> g.
>>
>>  Documentation/devicetree/booting-without-of.txt |   40
> +++++++++++++++++++++++
>>  1 files changed, 40 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/devicetree/booting-without-of.txt
> b/Documentation/devicetree/booting-
>> without-of.txt
>> index 6bca668..3950aea 100644
>> --- a/Documentation/devicetree/booting-without-of.txt
>> +++ b/Documentation/devicetree/booting-without-of.txt
>
> In order to make this more generic, perhaps it should change names, so
> that it is actually a description of what the file
> describes, as opposed to what it doesn't describe.  "booting.txt"?

I though about that, but I think I'd like to leave it as-is for the
time being so that it is easier for people to find where it has moved
to.

>
>> @@ -13,6 +13,7 @@ Table of Contents
>>
>>    I - Introduction
>>      1) Entry point for arch/powerpc
>> +    2) Entry point for arch/arm
>
> We should probably include microblaze here too...

Awesome, thanks for volunteering to write the patch!  :-)

g.
