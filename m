Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760604Ab0I1CoK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 22:44:10 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38920 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759826Ab0I1CoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 22:44:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=PQgQ6dBm0Yhot/YNhGOWSAzU4Q6NacJ7S0sX5j8mn5Jn2CjgoC6BnHH28Fl+k8LSY5
         wIYHZCQC6Qbno+3zmka3bvwV09V8jiCMprWXZiUs0DAUKUTH6PPQaoiSG67RK0W4wQDy
         HoF9f8K5KZvgdNxawAExD9CtuxSumUm7Vdn3M=
MIME-Version: 1.0
In-Reply-To: <20100927140028.GB856@srcf.ucam.org>
References: <1284702459-31646-1-git-send-email-keng-yu.lin@canonical.com>
 <1285325323-4528-1-git-send-email-keng-yu.lin@canonical.com> <20100927140028.GB856@srcf.ucam.org>
From: =?UTF-8?B?S2VuZy1Zw7wgTGlu?= <keng-yu.lin@canonical.com>
Date: Tue, 28 Sep 2010 10:43:44 +0800
X-Google-Sender-Auth: 5cg966UhtGST0c4fKAn2sISuyew
Message-ID: <AANLkTi=buauo9M=nLnZhEXm-do=Vt1mPwhq3oPFH9fQ_@mail.gmail.com>
Subject: Re: [PATCH v4] dell-laptop: Add debugfs support
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: len.brown@intel.com, alan-jenkins@tuffmail.co.uk, superm1@ubuntu.com,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 10:00 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> What's the difference between this version and v3?
>
> --
> Matthew Garrett | mjg59@srcf.ucam.org
>

Hi Mathew:
  V3 does not print the correct bit of hwswitch_state. I just found
that V4 messed up by the operator precedence; will send a new fix.

  Regards,
-kengyu
