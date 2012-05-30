Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324Ab2E3DlF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 23:41:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32802 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932308Ab2E3Dk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 23:40:29 -0400
Message-ID: <4FC59644.6060106@zytor.com>
Date: Tue, 29 May 2012 20:38:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
        "H.J. Lu" <hjl.tools@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>,
        Jarkko Sakkinen <jarkko.sakkinen@intel.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Len Brown <len.brown@intel.com>, Len Brown <lenb@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>, Michal Marek <mmarek@suse.cz>,
        Paolo Bonzini <pbonzini@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Sam Ravnborg <sam@ravnborg.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] x86 trampoline rework for 3.5
References: <201205292325.q4TNPBPw007366@terminus.zytor.com> <CA+55aFyjcbaRcK5yfi-xLc2W+AAk0EAY9fhNOc+-_uQdDzck6w@mail.gmail.com> <4FC58EFE.2070705@zytor.com> <CA+55aFyNJLYyC71rpNE+6kax+j_6ybN=GE_4fG1YKH2OevkRTg@mail.gmail.com>
In-Reply-To: <CA+55aFyNJLYyC71rpNE+6kax+j_6ybN=GE_4fG1YKH2OevkRTg@mail.gmail.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2012 08:19 PM, Linus Torvalds wrote:
> 
> I didn't see any git silent mis-merges, though. The fact that that
> relocs.c file had come in two different ways did make for a more
> interesting merge, since it didn't have any common ancestry - just two
> different original versions. But git seemed to do the right thing, and
> marked where they differed.
> 

I don't know why, but when I did a test merge of my original branch into
top of your tree, it silently merged everything (no markings) but
incorrectly.

Perhaps it is a git version-specific thing.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

