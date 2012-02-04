Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab2BDExb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 23:53:31 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:38945 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751692Ab2BDExa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 23:53:30 -0500
Message-ID: <1328331208.21255.51.camel@joe2Laptop>
Subject: Re: [PATCH] checkpatch: Warn on code with 6+ tab indentation
From: Joe Perches <joe@perches.com>
To: Tony Luck <tony.luck@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
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
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Date: Fri, 03 Feb 2012 20:53:28 -0800
In-Reply-To: <CA+8MBbLeWJ1ifBcJfj1MEO15tAuMBYHvu9kk7NNuUivOsNCWxw@mail.gmail.com>
References: <20120130140905.441199885@openvz.org>
	 <20120130141852.309402052@openvz.org> <20120203074656.GC30543@elte.hu>
	 <20120203083530.GD1968@moon> <20120203090929.GA23996@elte.hu>
	 <20120203012241.bcd3d0c8.akpm@linux-foundation.org>
	 <20120203095227.GA13162@elte.hu> <20120203100743.GA3334@elte.hu>
	 <CA+55aFxjPAsfsSSOsX9eyts6EP6dEyieGS_YJs-4HLuTKNfzZg@mail.gmail.com>
	 <1328311239.21255.24.camel@joe2Laptop>
	 <CA+8MBbLeWJ1ifBcJfj1MEO15tAuMBYHvu9kk7NNuUivOsNCWxw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-03 at 20:45 -0800, Tony Luck wrote:
> On Fri, Feb 3, 2012 at 3:20 PM, Joe Perches <joe@perches.com> wrote:
> > Another might be to limit variable name length to something
> > shorter than say 10 characters.
> 
> 10? We have a few cases of variables over 100 (not sure how you are supposed
> to use them with an 80 character max line length). Current longest is:
> 
> eOpenLogicalChannelAck_reverseLogicalChannelParameters_multiplexParameters_h2250LogicalChannelParameters

EUey.  (err, well maybe ITUey)

Remind me never to look at that code again.

