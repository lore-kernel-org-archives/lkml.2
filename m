Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752634Ab0LVHyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 02:54:49 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:65234 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab0LVHys convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 02:54:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cXFjQPftpfIMO2FjVux9Biys4LdO0HFnQdOVjRKAvZIUR2VzEzOsRZPaxS7otbkPmt
         C5rngFZ81xz2A+eEH/Kfq/g5rj5laT3RRqglcQk1Ju/29u3VCrR1budXHz8K3RJjUhkN
         2j/s5ywksNd7yGub+tAxpfBsPwyBAVN0jksbo=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=b45nmd+-yMKB_+AEyS6=9-aa+aBACUkZJLo_v@mail.gmail.com>
References: <1292866298-8585-1-git-send-email-per.forlin@stericsson.com>
	<AANLkTi=7E7rAc=46p5d6YSpLeut5yehmBtLa4TVofefp@mail.gmail.com>
	<AANLkTin=U6j4XTmCq4H4sKivD+jecxor3Q-7mYFDfD=N@mail.gmail.com>
	<AANLkTik94Go7W4AMquncm-novWkHtLOBRn7BfpepoEZz@mail.gmail.com>
	<AANLkTi=b45nmd+-yMKB_+AEyS6=9-aa+aBACUkZJLo_v@mail.gmail.com>
Date: Wed, 22 Dec 2010 08:54:47 +0100
Message-ID: <AANLkTin8g9EPa2xJQnLuM5+ujv7qCUE3xCBAu-uFC5ct@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: dma40: Add support to split up large elements
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Per Forlin <per.forlin@stericsson.com>, linux-kernel@vger.kernel.org,
        Per Forlin <per.forlin@linaro.org>,
        Rabin VINCENT <rabin.vincent@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/21 Dan Williams <dan.j.williams@intel.com>:

Thanks for clearing out the misunderstandings...

> If you want to send a patch that catches and reports this byte count
> in case some out of tree user submits a large request that would be an
> acceptable workaround for 37.  >64K support is a new feature for 38.

Nah noone else besides us would be using it right now and we have
this under control. No-one should be harmed. It's fair enough if it goes
into .38...

Yours,
Linus Walleij
