Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167Ab2BDD6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 22:58:38 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:33613 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753442Ab2BDD6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 22:58:37 -0500
Message-ID: <1328327915.21255.45.camel@joe2Laptop>
Subject: Re: [PATCH] checkpatch: Warn on code with 6+ tab indentation
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>, linux-kernel@vger.kernel.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu,
        Andy Whitcroft <apw@shadowen.org>, Ingo Molnar <mingo@elte.hu>
Date: Fri, 03 Feb 2012 19:58:35 -0800
In-Reply-To: <CA+55aFxGVS8+F+7nLJ90tuwj5_3wqJ3=bdRAx9XUQ95vOb2VyQ@mail.gmail.com>
References: <20120130140905.441199885@openvz.org>
	 <20120130141852.309402052@openvz.org> <20120203074656.GC30543@elte.hu>
	 <20120203083530.GD1968@moon> <20120203090929.GA23996@elte.hu>
	 <20120203012241.bcd3d0c8.akpm@linux-foundation.org>
	 <20120203095227.GA13162@elte.hu> <20120203100743.GA3334@elte.hu>
	 <CA+55aFxjPAsfsSSOsX9eyts6EP6dEyieGS_YJs-4HLuTKNfzZg@mail.gmail.com>
	 <1328311239.21255.24.camel@joe2Laptop>
	 <CA+55aFxHih0+P=aNromTy+f_Rt+++QWgaEdvqLsXg_q_hu_q2A@mail.gmail.com>
	 <1328319226.21255.28.camel@joe2Laptop>
	 <CA+55aFxqWFRNgR_C9sRCOQ6Vh9PF8anomZsfGD9HP49JgAb57A@mail.gmail.com>
	 <1328325697.21255.41.camel@joe2Laptop>
	 <CA+55aFxGVS8+F+7nLJ90tuwj5_3wqJ3=bdRAx9XUQ95vOb2VyQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-03 at 19:35 -0800, Linus Torvalds wrote:
> I think that grep convinced me that you are right about this
> particular pattern.

Oh good.

> Brr. Now I need to go dig my eyes out with a
> spoon.

Maybe you can keep that thought for your next
Halloween display for the local urchins...


