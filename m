Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab1GOQpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 12:45:44 -0400
Received: from smtp-out.google.com ([216.239.44.51]:34508 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab1GOQpn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 12:45:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=bSbcrUldo2Dr6eLXNWOAM9hWMNFeR+QFeXHMxUJS7K+TnbY4JqfIJgbDOZK6wflyZ
	qc352796Q0NxR7SikfLEA==
MIME-Version: 1.0
In-Reply-To: <20110715151916.GC4747@suse.de>
References: <1310675693-9204-1-git-send-email-mikew@google.com>
 <20110714212113.GA28639@suse.de> <CAGTjWtB53vW5B2EJ5=+C3buDAY0RtsfANxx5NhC5aWnmEx08EQ@mail.gmail.com>
 <20110715064147.GA1021@suse.de> <C70E3912-6AA9-4EB3-85CC-11BF90D230C8@mit.edu>
 <20110715145132.GA4296@suse.de> <20110715155835.4e019ca5@lxorguk.ukuu.org.uk> <20110715151916.GC4747@suse.de>
From: Mike Waychison <mikew@google.com>
Date: Fri, 15 Jul 2011 09:45:20 -0700
Message-ID: <CAGTjWtDszSANuye-y9MxvwE781DkVetG4m7XsjYpyMVFDTE+6w@mail.gmail.com>
Subject: Re: [PATCH 1/2] Kconfig: Allow disabling of CONFIG_DEVPORT
To: Greg KH <gregkh@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 8:19 AM, Greg KH <gregkh@suse.de> wrote:
> On Fri, Jul 15, 2011 at 03:58:35PM +0100, Alan Cox wrote:
>> > But none of them are on the Signed-off-by: line area, right?
>>
>> We have a fair number of people using things like
>>
>> Fixes-bug: [URL]
>>
>>
>> Its useful public info, it makes it easier to grep
>
> That's fine, but that is not what was done here.  And those URLs had
> better be public as well.
>

Greg, this is a bit ridiculous.  If adding a bug reference number to a
patch isn't used in lieu of a good patch description, I don't see how
this hurts anybody in the public.  You're only making it more
difficult for those who actually want to contribute to the public
sources.
