Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab1A1IqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 03:46:20 -0500
Received: from smtp-out.google.com ([74.125.121.67]:5558 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070Ab1A1IqS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 03:46:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rYMSAFpYAhNLa/WgGjndr/MGyDuIIFztT4fMnaDGgCrMnXLOU5L45Wym6eg+5EhUOh
         W3+LyxKxUBTQvj4Vklhw==
MIME-Version: 1.0
In-Reply-To: <AANLkTino3tzfri0MiPpMArsB8VGiKZh2aP85tv+psBbZ@mail.gmail.com>
References: <AANLkTim6zcdn8FgUTa7OO=_4B3x5CiHxWr_g=uR0m4zX@mail.gmail.com>
	<AANLkTino3tzfri0MiPpMArsB8VGiKZh2aP85tv+psBbZ@mail.gmail.com>
Date: Fri, 28 Jan 2011 00:46:11 -0800
Message-ID: <AANLkTin899Md9s5-EiK9WH4-FZp4aTJpWF6-wcWhfR0T@mail.gmail.com>
Subject: Re: [GIT PULL] ARM Tegra fixes for 2.6.38
From: Colin Cross <ccross@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-main <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Linux Tegra Mailing List <linux-tegra@vger.kernel.org>,
        Erik Gilling <konkers@android.com>, Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 12:42 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Jan 27, 2011 at 3:41 PM, Colin Cross <ccross@google.com> wrote:
>>
>> Please pull fixes for the Tegra machine from:
>>
>>  http://android.git.kernel.org/kernel/tegra.git for-linus
>
> I don't do http fetching. My life is too short. If there isn't a
> native git server, make one.
>
>               Linus
>

Sorry, the git server wasn't responding for me yesterday.  Please pull from:
git://android.git.kernel.org/kernel/tegra.git for-linus
