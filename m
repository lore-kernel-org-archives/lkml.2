Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664Ab0HNLVd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 07:21:33 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53952 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753952Ab0HNLVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 07:21:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=BwQMJN0c7iH6OKj0Rrbfhbc3nRG9H6EnPUmbGdPYooYzzZShwTBLEGWmJvWVXx7uPh
         NMFil7qjsN6jdSvpp8H7Sgr6Mu9d4//WoswS/07t2K0uNivC3nV7JspJbcIgFbMGhrjS
         /1ctZWvKmasJrKzxWRlBTkUdf+9PrgVPe3qak=
MIME-Version: 1.0
In-Reply-To: <a00737cba20cb46512a2248e0477cc0b@linux.psw.ro>
References: <20100813212313.GA22102@kroah.com>
	<a00737cba20cb46512a2248e0477cc0b@linux.psw.ro>
Date: Sat, 14 Aug 2010 14:21:31 +0300
X-Google-Sender-Auth: xamz6EKzThKSCuKaPkP720jyo8U
Message-ID: <AANLkTi=YfKZkE6ee6rE9LvtAiQ6F0YaTHbN+O_dTGHKb@mail.gmail.com>
Subject: Re: Linux 2.6.35.2
From: Pekka Enberg <penberg@kernel.org>
To: Arthur Titeica <arthur@psw.ro>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 14, 2010 at 1:35 PM, Arthur Titeica <arthur@psw.ro> wrote:
> On Fri, 13 Aug 2010 14:23:13 -0700, Greg KH <gregkh@suse.de> wrote:
>> I'm announcing the release of the 2.6.35.2 kernel.
>>
>> All users of the 2.6.35 kernel series must upgrade.
>>
>
> I'm not sure this is the right mailing list but this is the first
> kernel that fails to boot for me (since 2.6.33.x).
>
> The laptop just restarts right after "Freeing unused kernel memory:
> 628k freed"
>
> 2.6.35.1 is fine with the same .config.
>
> Anyone willing to help me to debug?

You could try 'git bisect' between v2.6.35.1 and v2.6.35.2 to narrow
the problem down to a specific commit.
