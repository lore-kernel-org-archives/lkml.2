Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180Ab2J0Ncy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 09:32:54 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37497 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab2J0Ncx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 09:32:53 -0400
MIME-Version: 1.0
In-Reply-To: <1351315222.1489.25.camel@anish-Inspiron-N5050>
References: <1351301025-5657-1-git-send-email-ming.lei@canonical.com>
	<1351315222.1489.25.camel@anish-Inspiron-N5050>
Date: Sat, 27 Oct 2012 21:32:50 +0800
Message-ID: <CACVXFVMTrtaBDG7umBK4_T5hUNf-ExeFgERuAsO5qzzkNJZFhw@mail.gmail.com>
Subject: Re: [PATCH v3] firmware loader: introduce module parameter to
 customize fw search path
From: Ming Lei <ming.lei@canonical.com>
To: anish kumar <anish198519851985@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2012 at 1:20 PM, anish kumar
<anish198519851985@gmail.com> wrote:
>>
>> +     [1], the 'path' is a string parameter which length should be less
> whose length should be less...

Maybe, but it is not a big deal, you may find some drivers can
keep one module string parameter length as 4096.

>> + * Typical usage is that passing 'firmware_class.path=$CUSTOMIZED_PATH'
>> + * from kernel command because firmware_class is generally built in
> do you mean kernel command line?

Yes.

Thanks,
--
Ming Lei
