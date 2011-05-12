Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab1ELShu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 14:37:50 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43408 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab1ELShj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 14:37:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AmvLLpo6oSYgxk/zs7l9+ISe0SmTObr6b//M7rMRLzoAsJzwad0wG0gwXbH6dYDm11
         hBX4e7fDBjKfNZnT8O+Xcx82vg7USy+8uii29m5Fsu8w+FheCq8B0/5TdP33UDruUtVE
         SO9CtiD+iYB5t+pdjIZgujL+5AR+mwUqBRkLY=
MIME-Version: 1.0
In-Reply-To: <20110512133402.GF15227@parisc-linux.org>
References: <cover.1305103212.git.mfm@muteddisk.com>
	<20110512133402.GF15227@parisc-linux.org>
Date: Thu, 12 May 2011 11:37:38 -0700
Message-ID: <BANLkTikE6cNwRTWwk-q3HONwPJqMQQ3vtQ@mail.gmail.com>
Subject: Re: [PATCH 00/12] staging: usbip: miscellaneous code cleanup
From: matt mooney <mfmooney@gmail.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 12, 2011 at 6:34 AM, Matthew Wilcox <matthew@wil.cx> wrote:
> On Wed, May 11, 2011 at 01:54:12AM -0700, matt mooney wrote:
>> Hi Greg,
>>
>> I am interested in hearing your thoughts on the userspace interface?
>
> Hey Matt, if you're looking at usbip, could I interest you in fixing
> the protocol that it speaks?  See the thread here:
>
> http://marc.info/?l=linux-kernel&m=122001863119269&w=2
>
> I ran out of time to work on it, but I think the problems still remain.

Hi Matthew,

I do plan on improving it where I can, so I will certainly take a look
at that thread.

Thanks,
matt

-- 
GPG-Key: 9AFE00EA
