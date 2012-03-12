Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab2CLLPi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 07:15:38 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060Ab2CLLPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 07:15:36 -0400
Message-ID: <4F5DDAD4.4060504@nod.at>
Date: Mon, 12 Mar 2012 12:15:32 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120215 Thunderbird/10.0.2
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: TTY: tty_port questions
References: <4F5BD51B.7030907@nod.at> <4F5BDB09.3020407@suse.cz> <4F5BE1E6.9000201@nod.at> <4F5C861F.2000507@nod.at> <4F5DCF39.8080308@nod.at> <20120312105312.665d2362@pyramind.ukuu.org.uk>
In-Reply-To: <20120312105312.665d2362@pyramind.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.03.2012 11:53, Alan Cox wrote:
>> Another question, what is the purpose of tty_port->console?
>> It seems to have no user.
>
> So the tty_port layer can in future know about whether it is a console
> without a tty necessarily being present or referenceable.
>
>> Is tty_port really the right thing for a console driver like in the UML
>> case?
>
> It will be. In order to fix the tty locking mess we need to shove a lot
> of stuff whose lifetime is the lifetime of the physical port somewhere
> else - the tty_port is that structure.
>

"It will be" in terms of "not now"? ;-)

Thanks,
//richard
