Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755022Ab0EGOd3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 10:33:29 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50962 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577Ab0EGOd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 10:33:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=YWlEA+6xoytWljRYbI7jvFb13CnKPeD9Ez5I2aNyXvCRg+YIt0ZbpS7N3kMiNCgOH3
         xAM8hVa0kPMdnfe+49/1UQdeaoWOPL0jxxIUjxlRJ86QxjRMYNmoLR7UauJ/R4kUpmYt
         AI5Tmo2UmiLn/gC6gPCmRvnaq72FbMrRYKkrY=
MIME-Version: 1.0
In-Reply-To: <h2mfbeb436f1005070727w982d8e7dnfb27319e104ece46@mail.gmail.com>
References: <h2mfbeb436f1005070727w982d8e7dnfb27319e104ece46@mail.gmail.com>
Date: Fri, 7 May 2010 16:33:27 +0200
Message-ID: <h2zfbeb436f1005070733v32b63f27mafe1b913da8cdd1f@mail.gmail.com>
Subject: Re: Documentation select_task_rq
From: sebastiano spicuglia <spicuglia.sebastiano@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am trying to implement a new schedule class.
I have got a problem with implementation of 'select_task_rq' function.

I don't know what the kernel supposes this function will do.
Wich are the requires and ensures of this function?

Thanks in advance.
Regards,
Sebastiano.
