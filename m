Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab0HBRuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 13:50:24 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52146 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924Ab0HBRuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 13:50:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=vBQcF3fJZpme9RKRtwhXudS+/+hw29FHy4rdsk5JxVOPudbs+L9BU8A7FW+eT6EEKK
         wUbUbOT+MfdEEy4R6YqX65bhzZT8Rf+fYDkf83rwEjntD9HYaIj81BnlRNFdeT3RrGG4
         vKRXOBijeagnw6wbjNHjvr951DjcRSbglM6Ok=
MIME-Version: 1.0
In-Reply-To: <cover.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de>
References: <cover.1280764206.git.qy03fugy@stud.informatik.uni-erlangen.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 2 Aug 2010 13:50:01 -0400
Message-ID: <AANLkTik_WZKS_SYFZkFMNf=J+GvJWR7jkJHoJAuOyYpT@mail.gmail.com>
Subject: Re: [PATCH 0/6] Removing dead code
To: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Cc: Jean Delvare <khali@linux-fr.org>, Tejun Heo <tj@kernel.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        vamos-dev@i4.informatik.uni-erlangen.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 2, 2010 at 11:56, Christian Dietrich wrote:
> There were many more dead flags in the vanilla kernel cause the config
> options were only introduced into the blackfin.uclinux.org kernel. I
> hope i just got patches for real problem flags[1]. Perhaps some
> syncing here would do something good for the blackfin arch.

yeah, our board resources often lead the rest of the tree in the
vanilla release.  this is because it's easy for us to merge board
resources without adversely impacting anything else, and sometimes we
dont know when the actual driver will get around to being merged.
-ike
