Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655Ab1DAO5e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 10:57:34 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48254 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757587Ab1DAO5c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 10:57:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Sr0AnROrhfOg5N5YArp1sgy5j9s/Zuz7MqLzJYGMqvnrqG3LAcvJnReqkrxwdjyUAz
         /143LZpyoU0Xzu8fbTJfV1mtjsd2b6nH0w5KRtON/bPlYNW0B8xh5yxpOPq+6kSjUfJO
         llVeRWT03/uOA7iaEbL8lk5ChpUae/ndXd3oA=
MIME-Version: 1.0
In-Reply-To: <BANLkTimpKhzHsZFSVrsZckfDQZ2GFwN1kw@mail.gmail.com>
References: <SNT111-DS16E628E3B6501DBCF9E19CA7BF0@phx.gbl> <BANLkTimpKhzHsZFSVrsZckfDQZ2GFwN1kw@mail.gmail.com>
From: Rafael Fernandez <rafaelefernandez@gmail.com>
Date: Fri, 1 Apr 2011 09:57:12 -0500
Message-ID: <BANLkTimoubhOk3tDwzgAek644C0AUCxN4w@mail.gmail.com>
Subject: Re: Minimum time slice for relaible Linux execution
To: limp <johnkyr83@hotmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also, how is this different than placing a starvation limit around the
RT set of tasks?

On Fri, Apr 1, 2011 at 9:19 AM, Rafael Fernandez
<rafaelefernandez@gmail.com> wrote:
> Hi,
>
> This is pretty interesting to me. How would your framework handle an
> RT application that does quite a bit of I/O? Does it block and go to
> Linux, get serviced, and come back?
>
> Thank you,
> Rafael
>
> On Thu, Mar 31, 2011 at 7:13 AM, limp <johnkyr83@hotmail.com> wrote:
>> Dear all,
>>
>> I have developed a framework similar to a hypervisor that switches between
>> Linux and a RT domain.
>> As RT priority is of highest importance, I want to give more time to the RT
>> domain *but* I also want to give Linux adequate time for being able to
>> operate.
>>
>> Could anyone advise me on how to determine the minimum possible time slice
>> that I can give to Linux so that it doesn't crash?
>>
>> That is, if I periodically execute my RT domain every ms and then I switch
>> to Linux, what's the minimum time that should be given to Linux, until the
>> next RT domain execution?
>>
>> NOTE: The RT domain and Linux are not executed concurrently, i.e. the RT
>> domain is executed first and then Linux executes until the next RT domain
>> execution.
>>
>> Thank you all in advance.
>>
>> John K.
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>



-- 
Rafael E. Fernández
B.S. Computer Science
University of Illinois at Urbana-Champaign
