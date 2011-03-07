Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab1CGCsM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 21:48:12 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39488 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab1CGCsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 21:48:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=LlP7Cy/DYmoxtYK+d912wPYoLoAeEouimTByy6FSPC7y/PxuVjmeJN7qQPz6cX+X8u
         DWj1HCPFfDthECH0QmA8rre9Xh1th/5T8A51ALoeogeDqVwCqVeohVDAjroWiIeIkgyx
         XaCZjrnPgWR1PorE+jObP3WzL3Ajias3Sch4Q=
MIME-Version: 1.0
In-Reply-To: <1299465664-7760-1-git-send-email-a.beregalov@gmail.com>
References: <1299465664-7760-1-git-send-email-a.beregalov@gmail.com>
Date: Mon, 7 Mar 2011 05:48:10 +0300
Message-ID: <AANLkTin2h7tKkNCA2AW66FyyuYafPNo4fpwUNYmFxh7x@mail.gmail.com>
Subject: Re: [PATCH next] staging: gma500: fix build according to drm changes
From: Alexander Beregalov <a.beregalov@gmail.com>
To: linux-kernel@vger.kernel.org, gregkh@suse.de
Cc: Alan Cox <alan@linux.intel.com>, Dave Airlie <airlied@gmail.com>,
        Alexander Beregalov <a.beregalov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 March 2011 05:41, Alexander Beregalov <a.beregalov@gmail.com> wrote:
> Commit 8410ea3b (drm: rework PCI/platform driver interface.)
> changed drm_driver structure. Fix build according to these changes.
>

Sorry, I forget to check LKML first, there is a patch already.
