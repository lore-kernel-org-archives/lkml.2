Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159Ab2BBUuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 15:50:18 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48621 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448Ab2BBUuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 15:50:16 -0500
To: Junio C Hamano <gitster@pobox.com>
Cc: git@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] Git 1.7.9
References: <7vipjwzvc2.fsf@alter.siamese.dyndns.org>
From: Jakub Narebski <jnareb@gmail.com>
Date: Thu, 02 Feb 2012 12:50:14 -0800 (PST)
In-Reply-To: <7vipjwzvc2.fsf@alter.siamese.dyndns.org>
Message-ID: <m3y5slark1.fsf@localhost.localdomain>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Junio C Hamano <gitster@pobox.com> writes:

> The latest feature release Git 1.7.9 is now available at the usual
> places.
> 
> The release tarballs are found at:
> 
>     http://code.google.com/p/git-core/downloads/list
> 
> and their SHA-1 checksums are:
> 
> ed51ef5ef250daaa6e98515cf2641820cd268d4c  git-1.7.9.tar.gz
> c7b1fa20dc501beb2cb5091dd24dbfd2a0013a0c  git-htmldocs-1.7.9.tar.gz
> 1ca1fc430b2814f9e9cf82ec3bf7f2eaf5209b7a  git-manpages-1.7.9.tar.gz

When trying to rebuild RPM out of tarball with

  $ rpmbuild -tb git-1.7.9.tar.gz

I get the following error at the end of build phase:

 RPM build errors:
     Installed (but unpackaged) file(s) found:
    /usr/share/locale/is/LC_MESSAGES/git.mo

Shouldn't this file be put in git package, or in separate 
git-i18n-is / git-i18n-Icelandic RPM package?

-- 
Jakub Narebski

