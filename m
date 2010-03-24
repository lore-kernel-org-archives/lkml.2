Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab0CXL5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 07:57:20 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:17350 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755793Ab0CXL5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 07:57:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=gGVliDoRgyJpk0zJyPUVS5PmX0/vcbkixH0PoSUpjWKulD1hTov6+2R/Xh9h5GgN0i
         SLRAsDcF0ythsqAiINlL53lJHbeKYKndYJL68xqV4qCcs20I1d4IiYQK/5UT5wlhlqeB
         vBbJIVcaOPoCGFhZjZMIbV8IJ0oHFTxa+QF0Q=
MIME-Version: 1.0
In-Reply-To: <84144f021003240400y43484fe6q8be4e8dc22284e9b@mail.gmail.com>
References: <1269420538-18039-1-git-send-email-tj@kernel.org>
	 <1269420538-18039-4-git-send-email-tj@kernel.org>
	 <84144f021003240400y43484fe6q8be4e8dc22284e9b@mail.gmail.com>
Date: Wed, 24 Mar 2010 13:57:17 +0200
Message-ID: <b6fcc0a1003240457x5aff83deo3aeac26f6bcf037@mail.gmail.com>
Subject: Re: [PATCH 3/4] include cleanup: Update gfp.h and slab.h includes to 
	prepare for breaking implicit slab.h inclusion from percpu.h
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Tejun Heo <tj@kernel.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Lee.Schermerhorn@hp.com, cl@linux-foundation.org, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, yi.zhu@intel.com,
       reinette.chatre@intel.com, ilw@linux.intel.com,
       Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 1:00 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> How do we get this merged before we grow more implicit dependencies?

Send it to Linus and cross fingers. ;-)
