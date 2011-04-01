Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971Ab1DAOTt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 10:19:49 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64020 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781Ab1DAOTs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 10:19:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=FOhwcwchjilLGpBfTLaqeqflVE9c1sbdbHj6JuZ+Yy6akIY3dHwlroains072n/7nW
         tvMpLl7TCxOfcpdN//FXAfX7u66lZHMkNzZCRkVi9bzNUtcawxry3UiJld9ZjlzF7+ST
         XGhNy8T1lKlghyudekVDiybs0gGxQdeNLivxc=
MIME-Version: 1.0
In-Reply-To: <SNT111-DS16E628E3B6501DBCF9E19CA7BF0@phx.gbl>
References: <SNT111-DS16E628E3B6501DBCF9E19CA7BF0@phx.gbl>
From: Rafael Fernandez <rafaelefernandez@gmail.com>
Date: Fri, 1 Apr 2011 09:19:28 -0500
Message-ID: <BANLkTimpKhzHsZFSVrsZckfDQZ2GFwN1kw@mail.gmail.com>
Subject: Re: Minimum time slice for relaible Linux execution
To: limp <johnkyr83@hotmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is pretty interesting to me. How would your framework handle an
RT application that does quite a bit of I/O? Does it block and go to
Linux, get serviced, and come back?

Thank you,
Rafael

On Thu, Mar 31, 2011 at 7:13 AM, limp <johnkyr83@hotmail.com> wrote:
> Dear all,
>
> I have developed a framework similar to a hypervisor that switches between
> Linux and a RT domain.
> As RT priority is of highest importance, I want to give more time to the RT
> domain *but* I also want to give Linux adequate time for being able to
> operate.
>
> Could anyone advise me on how to determine the minimum possible time slice
> that I can give to Linux so that it doesn't crash?
>
> That is, if I periodically execute my RT domain every ms and then I switch
> to Linux, what's the minimum time that should be given to Linux, until the
> next RT domain execution?
>
> NOTE: The RT domain and Linux are not executed concurrently, i.e. the RT
> domain is executed first and then Linux executes until the next RT domain
> execution.
>
> Thank you all in advance.
>
> John K.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
