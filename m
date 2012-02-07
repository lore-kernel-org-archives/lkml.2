Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977Ab2BGVTB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 16:19:01 -0500
Received: from mga10.intel.com ([192.55.52.92]:54778 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756695Ab2BGVS7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 16:18:59 -0500
MIME-Version: 1.0
In-Reply-To: <87zkcuh8iq.fsf@rustcorp.com.au>
References: <cover.1328122362.git.dmitry.kasatkin@intel.com>
	<alpine.LRH.2.00.1202061250400.16907@tundra.namei.org>
	<CALLzPKZSWSp6r-5e1c1Z6qOH6C0DcOz=LHJ20Y468SQE6UU1ww@mail.gmail.com>
	<87zkcuh8iq.fsf@rustcorp.com.au>
Date: Tue, 7 Feb 2012 23:18:38 +0200
Message-ID: <CALLzPKZRUTaOE8afXD1b=Kd6fOaisOpAW+XGJMi7uHdE0sEgFw@mail.gmail.com>
Subject: Re: [RFC][PATCH v1 0/2] integrity: module integrity verification
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Rusty Russell <rusty@ozlabs.org>
Cc: James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, zohar@linux.vnet.ibm.com,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 7, 2012 at 7:13 PM, Rusty Russell <rusty@ozlabs.org> wrote:
> On Mon, 6 Feb 2012 08:59:00 +0200, "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com> wrote:
>> On Mon, Feb 6, 2012 at 3:51 AM, James Morris <jmorris@namei.org> wrote:
>> > On Wed, 1 Feb 2012, Dmitry Kasatkin wrote:
>> >
>> >> Hi,
>> >>
>> >> Here is another module verification patchset, which is based on the recently
>> >> upstreamed digital signature support used by EVM and IMA-appraisal.
>> >
>> > You should cc: Rusty on any changes to the module code.
>> >
>>
>> Hello,
>>
>> Mimi already has pointed that out.
>> I have sent him an email with the link..
>
> Thanks.
>
> Using an external signature (via cmdline arguments) is simple, at
> least.  Not sure what the userspace side of this looks like?
>

Hello,

There are couple of patches for modprobe and insmod...

You could see them on the top at:
http://linux-ima.git.sourceforge.net/git/gitweb.cgi?p=linux-ima/module-init-tools.git;a=summary

It first tries to read signature from xattr, then from file...
"modprobe -v" will show 'ima='  parameter with signature.

- Dmitry


> Cheers,
> Rusty.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
