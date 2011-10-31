Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934602Ab1JaWYC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 18:24:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40605 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934111Ab1JaWYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 18:24:00 -0400
Message-ID: <4EAF1FF6.3000500@zytor.com>
Date: Mon, 31 Oct 2011 15:23:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
References: <20111026202235.GA20928@havoc.gtf.org> <1319969101.5215.20.camel@dabdike> <CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com> <4EAF1731.2070908@zytor.com> <CA+55aFy-qDrzi21EWWV1yxDoRzh5xzLR6ai6Cq1b+hMrNTk6Sw@mail.gmail.com>
In-Reply-To: <CA+55aFy-qDrzi21EWWV1yxDoRzh5xzLR6ai6Cq1b+hMrNTk6Sw@mail.gmail.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2011 03:21 PM, Linus Torvalds wrote:
> On Mon, Oct 31, 2011 at 2:46 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> What client are you using (or are you using the gmail web interface?)
> 
> I'm using the gmail web interface, but I can save the email
> individually for gpg checking. It's just that when I do that, no sane
> tool will actually check it (ie there is no equivalent of "gpg
> --verify" for that mbox) that I've found.
> 
> And it's kind of sad when the gpg inative nterfaces are better than
> some other tool. gpg is famous for having a *horrible* user interface.
> 

I use enigmail which is a Thunderbird plugin; it works quite well, but,
well, it requires Thunderbird.  I think many GUI MUAs have similar
plugins, but text MTAs might be worse, I don't know.

	-hpa

