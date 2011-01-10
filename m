Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab1AJXqO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 18:46:14 -0500
Received: from mail-gx0-f194.google.com ([209.85.161.194]:38352 "EHLO
	mail-gx0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab1AJXqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 18:46:11 -0500
X-Greylist: delayed 720 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Jan 2011 18:46:11 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type;
        b=uB7QluXdXwwQOlM10NnDyi8nmIq1NYUycEOwOrqVT+YdCCbbwtNMFTNFTSA/kj42ex
         Z9t300vW2aAf7ziRTCUyeV8ePQNa/k3JB/lH0fuAdrFokXd5RxEquhlC+l17vWwNFgrL
         XgbXKn3VP0ELoFbAQZAxxNX78V0eA/IUPOkmI=
MIME-Version: 1.0
In-Reply-To: <AANLkTimUrKOX6ydXx8zUukk2+fBYQxEsp3=6qZwm5KRD@mail.gmail.com>
References: <1294422307-19107-1-git-send-email-riyer@nvidia.com> <AANLkTimUrKOX6ydXx8zUukk2+fBYQxEsp3=6qZwm5KRD@mail.gmail.com>
From: Mohamed Ikbel Boulabiar <boulabiar@gmail.com>
Date: Tue, 11 Jan 2011 00:33:50 +0100
Message-ID: <AANLkTi=JYf-7biH=nptrgE6L_DiM5S84hTTzA_JiwquA@mail.gmail.com>
Subject: [PATCH v3] input: tegra-kbc - Add tegra keyboard driver
To: linux-kernel@vger.kernel.org, USB list <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 7, 2011 at 6:45 PM, <riyer@nvidia.com> wrote:
>
> This patch adds support for the internal matrix keyboard controller for
> Nvidia Tegra platforms.

Will you also post the nvidia's multitouch driver here ?
I have only seen the code used in android tablet and published for
android kernel.

i
