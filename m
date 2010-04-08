Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223Ab0DHD6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 23:58:20 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:59560 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790Ab0DHD6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 23:58:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=t9mLQgEt729wYNX7rgyq2eGhgzyyVKccNW7GowtoW0iaSRg0StiP7dk4XHWDKMtef7
         9hJWLZCtUego7E+YAeYeJ/qZgJWmVM/6s7IeKGj0fXpEgOK8z2jaVacMZowIDab2J9ic
         SdEDmvPPrDCw6e2oeKiQNwD8HRWu9vaovYOKA=
MIME-Version: 1.0
Date: Thu, 8 Apr 2010 11:58:17 +0800
Message-ID: <h2k5d592f661004072058hcdac7ab5y3eceeaab28f6fbe0@mail.gmail.com>
Subject: BUG? boot failed with "crashkernel=256M@32M", but 
	"crashkernel=256M@64M" can work
From: Ryan Wang <openspace.wang@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

        I have setup kdump on my box, but failed on booting with
                       "crashkernel=256M@32M".
Then I tried
                       "crashkernel=256M@64M"
and succeeded.

       Is it a bug of kernel?

thanks,
