Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933573Ab1CXE4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 00:56:35 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42386 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab1CXE4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 00:56:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :user-agent;
        b=M1LJWny1Oxb/VCAchmGdNi9U4IttGqKzfV0PypqlBqcawHogLf3YThimvzJofRASmQ
         /zuZkIJGNMvtSvd4xIWaAdIQ3gHdeX84eto8RhAJtWqLMo+O9msRg5BShjirNxChb7eB
         VxIb1vYzLC9A4HtCaFmF0N5FBVAU+inISYXes=
Date: Thu, 24 Mar 2011 12:56:12 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, joe@perches.com, akpm@linux-foundation.org,
        rdunlap@xenotime.net
Subject: [BUG]Some warnings happened when compile UML kernel.
Message-ID: <20110324045610.GA8186@gmail.com>
Mail-Followup-To: linux-kernel@vger.kernel.org, greg@kroah.com,
	joe@perches.com, akpm@linux-foundation.org, rdunlap@xenotime.net
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi us,
	Recently, i wanna establish a UML for something else. But
When i compile the UML kernel with linux-2.6.38, it shows some 
OOPS like following. Maybe they are well. I just worry they will lead
to some other matters.

root@jiawei-laptop:/usr/src/linux-2.6.38# make gconfig ARCH=um
sed < scripts/kconfig/lkc_proto.h > scripts/kconfig/lkc_defs.h 's/P(\([^,]*\),.*/#define \1 (\*\1_p)/'
  HOSTCC  scripts/kconfig/gconf.o
In file included from /usr/include/gtk-2.0/gtk/gtk.h:233,
                 from /usr/include/libglade-2.0/glade/glade-xml.h:26,
                 from /usr/include/libglade-2.0/glade/glade.h:28,
                 from scripts/kconfig/gconf.c:16:
/usr/include/gtk-2.0/gtk/gtkitemfactory.h:47: warning: function declaration isn¡¯t a prototype
scripts/kconfig/gconf.c:82: warning: no previous prototype for ¡®dbg_sym_flags¡¯
scripts/kconfig/gconf.c:112: warning: no previous prototype for ¡®replace_button_icon¡¯
scripts/kconfig/gconf.c:131: warning: no previous prototype for ¡®init_main_window¡¯
scripts/kconfig/gconf.c:217: warning: no previous prototype for ¡®init_tree_model¡¯
scripts/kconfig/gconf.c:247: warning: no previous prototype for ¡®init_left_tree¡¯
scripts/kconfig/gconf.c:291: warning: no previous prototype for ¡®init_right_tree¡¯
scripts/kconfig/gconf.c:444: warning: no previous prototype for ¡®on_window1_delete_event¡¯
scripts/kconfig/gconf.c:489: warning: no previous prototype for ¡®on_window1_destroy¡¯
scripts/kconfig/gconf.c:496: warning: no previous prototype for ¡®on_window1_size_request¡¯
scripts/kconfig/gconf.c:532: warning: no previous prototype for ¡®on_load1_activate¡¯
scripts/kconfig/gconf.c:573: warning: no previous prototype for ¡®on_save_as1_activate¡¯
scripts/kconfig/gconf.c:593: warning: no previous prototype for ¡®on_quit1_activate¡¯
scripts/kconfig/gconf.c:600: warning: no previous prototype for ¡®on_show_name1_activate¡¯
scripts/kconfig/gconf.c:611: warning: no previous prototype for ¡®on_show_range1_activate¡¯
scripts/kconfig/gconf.c:629: warning: no previous prototype for ¡®on_show_data1_activate¡¯
scripts/kconfig/gconf.c:641: warning: no previous prototype for ¡®on_set_option_mode1_activate¡¯
scripts/kconfig/gconf.c:650: warning: no previous prototype for ¡®on_set_option_mode2_activate¡¯
scripts/kconfig/gconf.c:659: warning: no previous prototype for ¡®on_set_option_mode3_activate¡¯
scripts/kconfig/gconf.c:667: warning: no previous prototype for ¡®on_introduction1_activate¡¯
scripts/kconfig/gconf.c: In function ¡®on_introduction1_activate¡¯:
scripts/kconfig/gconf.c:690: warning: format not a string literal and no format arguments
scripts/kconfig/gconf.c: At top level:
scripts/kconfig/gconf.c:698: warning: no previous prototype for ¡®on_about1_activate¡¯
scripts/kconfig/gconf.c: In function ¡®on_about1_activate¡¯:
scripts/kconfig/gconf.c:708: warning: format not a string literal and no format arguments
scripts/kconfig/gconf.c: At top level:
scripts/kconfig/gconf.c:716: warning: no previous prototype for ¡®on_license1_activate¡¯
scripts/kconfig/gconf.c: In function ¡®on_license1_activate¡¯:
scripts/kconfig/gconf.c:727: warning: format not a string literal and no format arguments
scripts/kconfig/gconf.c: At top level:
scripts/kconfig/gconf.c:735: warning: no previous prototype for ¡®on_back_clicked¡¯
scripts/kconfig/gconf.c:750: warning: no previous prototype for ¡®on_load_clicked¡¯
scripts/kconfig/gconf.c:756: warning: no previous prototype for ¡®on_single_clicked¡¯
scripts/kconfig/gconf.c:766: warning: no previous prototype for ¡®on_split_clicked¡¯
scripts/kconfig/gconf.c:782: warning: no previous prototype for ¡®on_full_clicked¡¯
scripts/kconfig/gconf.c:794: warning: no previous prototype for ¡®on_collapse_clicked¡¯
scripts/kconfig/gconf.c:800: warning: no previous prototype for ¡®on_expand_clicked¡¯
scripts/kconfig/gconf.c:940: warning: no previous prototype for ¡®on_treeview2_button_press_event¡¯
scripts/kconfig/gconf.c:997: warning: no previous prototype for ¡®on_treeview2_key_press_event¡¯
scripts/kconfig/gconf.c:1042: warning: no previous prototype for ¡®on_treeview2_cursor_changed¡¯
scripts/kconfig/gconf.c:1058: warning: no previous prototype for ¡®on_treeview1_button_press_event¡¯
scripts/kconfig/gconf.c:1273: warning: no previous prototype for ¡®gtktree_iter_find_node¡¯
scripts/kconfig/gconf.c:1481: warning: no previous prototype for ¡®fixup_rootmenu¡¯
scripts/kconfig/images.c:6: warning: ¡®xpm_load¡¯ defined but not used
scripts/kconfig/images.c:36: warning: ¡®xpm_save¡¯ defined but not used
scripts/kconfig/images.c:66: warning: ¡®xpm_back¡¯ defined but not used
scripts/kconfig/images.c:175: warning: ¡®xpm_symbol_no¡¯ defined but not used
scripts/kconfig/images.c:192: warning: ¡®xpm_symbol_mod¡¯ defined but not used
scripts/kconfig/images.c:209: warning: ¡®xpm_symbol_yes¡¯ defined but not used
scripts/kconfig/images.c:226: warning: ¡®xpm_choice_no¡¯ defined but not used
scripts/kconfig/images.c:243: warning: ¡®xpm_choice_yes¡¯ defined but not used
scripts/kconfig/images.c:277: warning: ¡®xpm_menu_inv¡¯ defined but not used
scripts/kconfig/images.c:294: warning: ¡®xpm_menuback¡¯ defined but not used
scripts/kconfig/gconf.c:893: warning: ¡®renderer_toggled¡¯ defined but not used
  HOSTCC  scripts/kconfig/kconfig_load.o
  HOSTLD  scripts/kconfig/gconf

Thanks.
Best Regards.
Harry Wei.
