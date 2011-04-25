Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab1DYFg3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 01:36:29 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:53308 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab1DYFg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 01:36:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=LJxzP1EIVxYuxvLFhDHSIwHZ1iyGNKpOBVftEHuDGuXboqwKDef949OuG7pXmNmrFB
         zrxjutcbNuFKEIzbqK2RjXMHBWl6/ZRgcmtngEf8mD3Zs09CiBiNanQcMaU1wnbNIyjk
         FMUDLz8NzEmrA4j0ZYF/hcAudhHeZyvYk7zMU=
Message-ID: <4DB50854.8090700@gmail.com>
Date: Mon, 25 Apr 2011 15:36:20 +1000
From: Graeme Russ <graeme.russ@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: U-Boot Users <u-boot@lists.denx.de>
Subject: Expanding checkpatch for non-linux (specifically U-Boot) use
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

There has been a bit of discussion lately on the U-Boot mailing list
regarding the use of checkpatch for U-Boot patches (see
http://lists.denx.de/pipermail/u-boot/2011-April/090954.html)

U-Boot uses the Linux coding style and checkpatch is therefore a very good
tool for us to use to check style compliance. However, checkpatch has a few
Linux specific checks which throw up false warnings for U-Boot patches like:

WARNING: consider using kstrto* in preference to simple_strto*
WARNING: Use #include <linux/$file> instead of <asm/$file>

Also, checkpatch seems to be checking not only patched lines, but context
lines as well. There is a policy for U-Boot patches to not intermix
whitespace / code cleanup changes and functional changes in in the same
patch. So to achieve zero warnings and errors, the submitter is forced to
create an additional code-cleanup patch in addition to the functionality
patch. The code cleanup can end up being significantly larger than the
functionality change which discourages casual submitters.

So I have a pretty simple question to ask of LKML - Will checkpatch patches
to create a 'U-Boot' command-line option to explicitly filter out Linux
specific warnings and errors ever be accepted into checkpatch, or will we
be required to create and maintain a U-Boot specific version?

P.S. If you could please keep the U-Boot mailing list Cc'd, that would be
appreciated

Regards,

Graeme





