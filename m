Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755909Ab2JZDNm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 23:13:42 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:45398 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755671Ab2JZDNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 23:13:40 -0400
MIME-Version: 1.0
In-Reply-To: <20121025191622.GA4088@kroah.com>
References: <1351144271-24443-1-git-send-email-sj38.park@gmail.com> <20121025191622.GA4088@kroah.com>
From: SeongJae Park <sj38.park@gmail.com>
Date: Fri, 26 Oct 2012 12:13:19 +0900
Message-ID: <CAEjAshp1zR=cMht71q5nt5_PCM8uozEhwO7D3Un0y4MPhxebBg@mail.gmail.com>
Subject: Re: [PATCH 1/2] Remove CsrEventHandle and functions using it
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for comment.
I will make and send patch again.

Thanks and Regards.
SeongJae Park.

On Fri, Oct 26, 2012 at 4:16 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Thu, Oct 25, 2012 at 02:51:10PM +0900, SeongJae Park wrote:
>> Nobody use CsrEventHandle, Nobody call function using it as parameter.
>> So, remove it.
>>
>> Signed-off-by: SeongJae Park <sj38.park@gmail.com>
>> ---
>>  drivers/staging/csr/csr_framework_ext.h       |   61 -------------------------
>>  drivers/staging/csr/csr_framework_ext_types.h |    2 -
>>  2 files changed, 63 deletions(-)
>
> This patch applies with fuzz, which implies that you didn't make it
> against the latest tree.  Care to redo it, and the 2/2 patch, against
> either my staging-next branch of the staging.git tree, or the next
> linux-next release that will happen tomorrow, and resend them?
>
> thanks,
>
> greg k-h
