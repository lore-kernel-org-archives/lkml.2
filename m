Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202Ab0JHKTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 06:19:21 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:50191 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756961Ab0JHKTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 06:19:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=SuVPRqKY0PtS1PeGPHY+KBGkvyZ2IAFqM/z7I3De8EuBeka+jBWTMvTsFbAo2SD7/d
         mvfKzEJSmOqOx9/tEVz6wxGu+XY9pmCS9yUH75VCpMAjt7lU0TMZpp9uYFsHUe4DWc2W
         S5sNwfr4cCbLqFIcVsJosl+iFEtWRvQcf9a4s=
MIME-Version: 1.0
Date: Fri, 8 Oct 2010 06:19:19 -0400
Message-ID: <AANLkTik6XbkhvwO1OgkgXDmBSVL8_s24zTEVwkK9Uwo4@mail.gmail.com>
Subject: [PATCH 0/3] Staging: speakup: Fixed a few things
From: T Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Tracey Dent <tdent48227@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

Here a few changes I did that you should apply. I will do more general
cleanups, when I get home from school. But this is all I can do at the
current time.

Patch series is based off your staging-next tree
commit-588abaa64b76005f6ab1a7d40770dcef12fd00ad.

Thanks,

Tracey Dent
