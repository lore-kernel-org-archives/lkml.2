Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777Ab2CZWrd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 18:47:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60802 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752433Ab2CZWrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 18:47:32 -0400
Message-ID: <4F70F1EC.3070004@zytor.com>
Date: Mon, 26 Mar 2012 15:47:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Daniel Drake <dsd@laptop.org>
CC: Andrew Morton <akpm@linux-foundation.org>, mingo@redhat.com,
        tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
        dilinger@queued.net, pgf@laptop.org
Subject: Re: [PATCH v4] x86, olpc: add debugfs interface for EC commands
References: <20120326180710.8DF9C9D401E@zog.reactivated.net> <20120326142908.c5248aec.akpm@linux-foundation.org> <CAMLZHHSD8eRd17NyUb=Druj==4Eh+XtY=86vGQUGU1fiPMcMNg@mail.gmail.com>
In-Reply-To: <CAMLZHHSD8eRd17NyUb=Druj==4Eh+XtY=86vGQUGU1fiPMcMNg@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2012 03:45 PM, Daniel Drake wrote:
> On Mon, Mar 26, 2012 at 3:29 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>> s/fix/break/?  "Originally-from" is not a recognised tag.  If this code
>> is based upon an earlier version from Paul then Signed-off-by: is
>> correct.
>>
>> What's going on here?  What are you trying to communicate?
> 
> I'm trying to take Ingo's suggestion, in the thread "[patch 1/8] x86,
> olpc: add debugfs interface for EC commands" he wrote:
> 
> ====
> This is not a valid signoff sequence - the 'From: ' author of
> the patch must be the first SOB line.
> 
> The way to do this is either to have a:
> 
>  From: Paul Fox <pgf@laptop.org>
> 
> or to covert Paul Fox's SOB to a credit line, such as:
> 
>  Originally-from: Paul Fox <pgf@laptop.org>
> ====
> 
> The original code was from Paul Fox. I changed it somewhat
> significantly, and Paul approves of the end result.
> Can someone suggest a way of expressing this, including tag ordering,
> that will be accepted by all parties?  :)
> 

My recommendation is:

Originally-by: Paul Fox <pgf@laptop.org>

... followed by Signed-off-by: in the order of patch flow.  Approving a
patch, when not passing through, is indicated by Acked-by: or Reviewed-by:

	-hpa

