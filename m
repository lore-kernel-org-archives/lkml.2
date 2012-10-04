Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab2JDWCs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 18:02:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:65209 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933718Ab2JDVUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:20:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: David Howells <dhowells@redhat.com>
Subject: Re: [GIT PULL] Disintegrate UAPI for asm-generic
Date: Thu, 4 Oct 2012 21:20:48 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>
References: <17336.1349380256@warthog.procyon.org.uk>
In-Reply-To: <17336.1349380256@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201210042120.48955.arnd@arndb.de>
X-Provags-ID: V02:K0:ftCkwSMxB53O4NVbrWMQWFCUqpLu8FZL/8+WLYpT1aD
 gTA+7llHJFCTfVK3TTWX++WNH2iclfhmBMpgxfvSDUWroasB8J
 Z8JivnY2AV8DH7T0K9YV3Ot2m79VTQKygVRLUgdAI5LIsNxSAq
 c6YvcGinbjmNRCIQst/A9T1O6r2ANUCA5DntyFSScWRjSnfjqj
 wiY4SOSrcxoGCjc+YJUZVrY2shicpDcPdiBVEMy9zrMTp1caUW
 zTCvkXnYY8JR4538pB3L/QUKm8faHRC8O/NkB7RLhTump5j24t
 h/0GebHq7hcKLAAKWfR/hlU7xYloqqa+wUv+/9xdxSuC2B3pqE
 O4DcIc7D3RNzrJwnhK4k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 October 2012, David Howells wrote:
> Can you merge the following branch into the asm-generic tree please.
> 
> This is to complete part of the UAPI disintegration for which the preparatory
> patches were pulled recently.
> 
> Note that there are some fixup patches which are at the base of the branch
> aimed at you, plus all arches get the asm-generic branch merged in too.
> 
> The following changes since commit 612a9aab56a93533e76e3ad91642db7033e03b69:
> 
>   Merge branch 'drm-next' of git://people.freedesktop.org/~airlied/linux (2012-10-03 23:29:23 -0700)
> 
> are available in the git repository at:

Ok, I've pulled it into the asm-generic branch and added it to the arm-soc
for-next branch, because that is convenient for me to get it into linux-next.

Olof, I'll send this to Linus in a couple of days, separate from the other arm-soc
stuff that I assume you are handling. I could also send everything in one go
if you prefer.

	Arnd
