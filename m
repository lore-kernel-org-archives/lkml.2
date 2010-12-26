Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab0LZN5I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 08:57:08 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49818 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab0LZN5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 08:57:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=qI+Bd3iX6p5c7JW8bD0e7PndEPAMK8mskIbmYwEQcOEp3hDVI3KfoOnZk2ZO1wpGNZ
         NFOyLVHi23KBjTT4YzOnI3AJh9bEtQG3yFdkO603L16qq0NNn2FjqyEJ56/wYsazYkXo
         I7qs1ptdYxYaffFZM3m14uc70zwR2AEWS/rU4=
Message-ID: <4D1748D4.5050700@gmail.com>
Date: Sun, 26 Dec 2010 14:53:24 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Linux FS Devel <linux-fsdevel@vger.kernel.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Return value of generic xattr operations
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

is it right that generic_setxattr & co. return -EOPNOTSUPP if there is a
namespace error? I mean, if the user try to set <my own namespace>.foo
attribute, the return value should be -EINVAL, isn't it? Operation not
supported means that extended attributes are not enabled or not
implemented by the fs. The man pages are not much clear about this
point. What do you think?

Marco
