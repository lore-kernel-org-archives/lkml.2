Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760379Ab2EIQ4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 12:56:09 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:36143 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760367Ab2EIQ4G convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:2:1>);
	Wed, 9 May 2012 12:56:06 -0400
Message-Id: <4FAABDDA0200007800082998@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 09 May 2012 17:56:26 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Bjorn Helgaas" <bhelgaas@google.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        "Jesse Barnes" <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 1/5, resend] PCI: adjust quirk handler section
 annotations
References: <4FAA4A5A0200007800082702@nat28.tlf.novell.com>
 <CAErSpo68N5JYv_SX7Qzu4e0Z=x_g1U+FPaA-ux_W_zoB6iW+pw@mail.gmail.com>
 <4FAAB134020000780008294F@nat28.tlf.novell.com>
 <CAErSpo5Aidio0a6SjeYu=-9gXJU1aALMi5mUjg2aEB5pTsr8=Q@mail.gmail.com>
In-Reply-To: <CAErSpo5Aidio0a6SjeYu=-9gXJU1aALMi5mUjg2aEB5pTsr8=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 09.05.12 at 18:08, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Wed, May 9, 2012 at 9:02 AM, Jan Beulich <JBeulich@suse.com> wrote:
>>>>> On 09.05.12 at 17:54, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>> My inclination is that all PCI fixups should work the same for
>>> hot-added devices as for those present at boot, which would suggest
>>> that we should always use __devinit, not __init.  If I'm missing
>>> something, please educate me :)
>>
>> That's certainly possible - I simply based the patch on what is there
>> currently.
> 
> Yep, your patch makes perfect sense considering the tree as it is
> today.  But if you agree with my sense of what it *should* be, I think
> we should leave things as they are, or work on moving everything

I indeed wondered why it isn't that way while doing this.

> towards __devinit (I'd be thrilled if you wanted to work on that :)).
> Otherwise we'd just be changing things to __init that we'd have to
> change back later.

I'd perhaps rather drop my patches then, as the main benefit
(moving stuff from resident text to init text) would go away.

Jan

