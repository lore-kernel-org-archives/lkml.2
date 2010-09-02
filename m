Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378Ab0IBTFk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 15:05:40 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54181 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab0IBTFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 15:05:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=R/wEcuVbnx7syXUE8cEZo0aOR7Pi9HPXo23yTg61A1dzbXZwA2IsW6QijT2VaciDqc
         DuIJCuzwlUsBgkzARpehw/Tfu0VCNa4oxDHZRpA2IotNNlEUWFF1t43v6SzX9RvcpQS0
         3yJPbqT49gXH5UGJ5r0ei9lj6QVLOPQmrZZHo=
MIME-Version: 1.0
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Thu, 2 Sep 2010 16:05:14 -0300
Message-ID: <AANLkTi=Y7RmojC2+1Zdw0jeGm99Gj7anVqReJkrgDmRg@mail.gmail.com>
Subject: [RFC] Fix typos
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'd like to know if it's worth fixing all typos found in comments,
documentation and sometimes code. A first attempt to do that you can
find at http://people.profusion.mobi/~lucas/kernel-typos-fix.patch

This was done by using the list of common typos available at
http://en.wikipedia.org/wiki/Wikipedia:Lists_of_common_misspellings

I already removed some false positives, but there are more. Before
going ahead and verifying all of them, I'd like to know whether this
would be a good patch.



-- 

Lucas De Marchi
