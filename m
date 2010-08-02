Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab0HBRjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 13:39:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36741 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab0HBRjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 13:39:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=CsL0RbCfHQJDUp7DlVQWShJNezc5CFFSRh4f8jp9hgL3aR409uMJCOKp5xf4ccW5wK
         fT5K4mjQkowItas3r43gvxtZgyHRpaa/Nrg54aQcaDkf7WzVTjywmvXMOPF9Fm9dLSU6
         lGycWykEPIyHnd08UwXJ0xLsT+hI5y5pG5KzY=
MIME-Version: 1.0
In-Reply-To: <6687666b92a0346df6ed876380aecc40e4f9f180.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de> 
	<6687666b92a0346df6ed876380aecc40e4f9f180.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 2 Aug 2010 13:38:46 -0400
Message-ID: <AANLkTi==+iJVjT4pnNKi2LWv4e-K_M2pvoBH_e2Axs53@mail.gmail.com>
Subject: Re: [PATCH 4/6] arch/blackfin: Remove dead CONFIG_REGULATOR_ADP_SWITCH
To: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Cc: uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        vamos-dev@i4.informatik.uni-erlangen.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 2, 2010 at 12:02, Christian Dietrich wrote:
> REGULATOR_ADP_SWITCH doesn't exist in Kconfig, therefore removing all
> references for it from the source.

we have patches pending locally to take care of this in a different
way, so i'll stick with those
-mike
