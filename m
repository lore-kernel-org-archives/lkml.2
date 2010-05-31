Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab0EaGJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 02:09:53 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60365 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab0EaGJs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 02:09:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ocpCJsMSqo5k/XoGYxIJ5FZ1R487GqFp5TPz90p7SqrfmjcEkpoD3Dgus2Da7hM1TN
         tG28Ek1k1t3qfUsv5c/cpVxaN7sjsQVbIB//3KA61wpmoBCN2vI/cusgI9nOY9VtfQpT
         WCXzh9Y27LxtVwhdmKh2wS1Bk46q3diKH+Jas=
MIME-Version: 1.0
In-Reply-To: <vbf0pu1dqa60ojk7uuublww9.1275282082699@email.android.com>
References: <vbf0pu1dqa60ojk7uuublww9.1275282082699@email.android.com>
Date: Mon, 31 May 2010 16:09:48 +1000
Message-ID: <AANLkTinAnHYDxFEKT69jPXZVoQ0I2Lmx4Q5I_kPDBugv@mail.gmail.com>
Subject: Re: [RFC] Try a bit harder to get output on the screen at panic time
From: Dave Airlie <airlied@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>, dri-devel@lists.freedesktop.org,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       James Simmons <jsimmons@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 3:03 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> I'll test again this week.  I still don't see how these small patches could cause issues with suspend/resume unless we set oops_in_progress during that time on your machine...
>
> Jesse

I've just given these a test on the EL6 kernel, and they seem to be
working well for me here,

They don't seem to break s/r here at least, and I can see crashes now
on screen which is a win. I'll get some time to try and set them up
for upstream asap.

Dave.
