Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750995Ab1CPNnq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 09:43:46 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38558 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab1CPNnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 09:43:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=q2GVyiWzhygnliXlcOaVeQP3FVCXdHVoYxK1+vZZolKxYDyfO8VYK8XQduVCy6mACy
         tHfvPycZOQzu9zq2ba6YPIf6YKn7WHG4oQLBDz/b3tF8IjEqvfyoQr+pFDuyax14s0E0
         oyN2/77q6aDKPN1wI39D4EcYAIsV8aBOy1RuY=
Date: Wed, 16 Mar 2011 16:43:37 +0300
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Benson Leung <bleung@chromium.org>
Cc: Rhyland Klein <rklein@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] power: bq20z75: Fix time and temp units
Message-ID: <20110316134337.GB12394@oksana.dev.rtsoft.ru>
References: <1298853672-21330-1-git-send-email-bleung@chromium.org>
 <1298857308-22790-2-git-send-email-bleung@chromium.org>
 <1299697239.12209.1.camel@rklein-linux2>
 <AANLkTi=7_+hRgGFOyOuN2VKD8jQRaL5AKi=ih-x+3Ck7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTi=7_+hRgGFOyOuN2VKD8jQRaL5AKi=ih-x+3Ck7@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 02:41:52AM -0700, Benson Leung wrote:
> Hi Anton,
> 
> Rhyland has LGTM'd my change to the bq20z75 driver to fix temperature
> and time units. Can it go upstream?

Sorry for the delay, the patch is now applied.

Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
