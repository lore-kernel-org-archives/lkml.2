Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab0HQCr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 22:47:57 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:40741 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783Ab0HQCrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 22:47:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=q7TJ5EPZZkrYwaHVCAKIPtaK8p3xyGY6GPyb1Sw4VP4Lrq87O/Bu93Ua2/Ys7TqDbz
         pwhKx1fWL3U+YOT1R8TqEpM8xIgx4kd/oap44Wu48nCXs3In0wthJWdsbuqmUPNGtqbn
         mFDs5t9OEroPabq5bqenwm+b+KCretUEmSs5E=
Date: Tue, 17 Aug 2010 10:51:44 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jon Masters <jcm@jonmasters.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] modules: don't call depmod when overriding external
 module install path
Message-ID: <20100817025144.GA5095@cr0.nay.redhat.com>
References: <1281945814-9720-1-git-send-email-jcm@jonmasters.org>
 <201008162013.46252.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008162013.46252.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 16, 2010 at 08:13:45PM +0930, Rusty Russell wrote:
>On Mon, 16 Aug 2010 05:33:34 pm Jon Masters wrote:
>> Recent kernels include an additional call to depmod during the installation
>> of external kernel modules as a convenience, in order to ensure that those
>> modules are picked up by the module loading tools/initramfs scripts, etc.
>> Although this call is potentially of some value, it should not be made
>> when explicitly setting INSTALL_MOD_PATH to a different location. This
>> avoids creating extraneous modules.* files that will never be used.
>> 
>> Signed-off-by: Jon Masters <jcm@jonmasters.org>
>
>Acked-by: Rusty Russell <rusty@rustcorp.com.au>
>
>I leave the Makefile stuff to the kbuild people...
>

Looks good for me,

Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
